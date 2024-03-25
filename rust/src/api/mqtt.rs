use rumqttc::{MqttOptions, Client, QoS,Connection,Event,Incoming,RecvTimeoutError,ConnectionError};
use crate::frb_generated::StreamSink;
use std::borrow::{Borrow, BorrowMut};
use std::error::Error;
use std::time::Duration;
use std::sync::{Arc,Mutex};
use std::marker::{Sync,Send};
use crossbeam_channel::{bounded,Sender,Receiver};
use std::ops::Drop;
use std::cell::Cell;
pub enum QosNative{
    AtLeastOnce,
    AtMostOnce,
    ExactlyOnce
}
pub struct MqttClient{
    pub client:Mutex<Option<Cell<Client>>>,
    pub connection:Mutex<Option<Cell<Connection>>>,
    pub operate_locker:Mutex<bool>,  //防止多次点击链接，重复赋值client和connection
    pub exit_flag:Mutex<bool>,
    pub tx:Sender<String>,
    pub rx:Receiver<String>,
}
impl Drop for MqttClient{
    fn drop(&mut self){
        println!("mqtt object drop");
        self.exit();
    }
}
impl MqttClient{

    #[flutter_rust_bridge::frb(sync)]
    pub fn new()->Self{
        println!("ok");
        let (mut tx,mut rx) = bounded(5);
        MqttClient{
            client:Mutex::new(None),
            connection:Mutex::new(None),
            operate_locker:Mutex::new(false),
            exit_flag:Mutex::new(false),
            tx:tx,
            rx:rx,
        }
    }
    pub fn connect(&self,id:String,host:String,port:u16){
        let mut options = MqttOptions::new(id, host, port);
        options.set_keep_alive(Duration::from_secs(5));
        let (mut client,mut connection) = Client::new(options ,10);
        if let Ok(mut locker) = self.client.lock(){
            *locker = Some(Cell::new(client));
        }
        if let Ok(mut locker) = self.connection.lock(){
            *locker = Some(Cell::new(connection));
        }
   }
    pub fn subscribe(&self,topic:String,qos:QosNative){
        if let Ok(mut locker) = self.client.lock(){
            if locker.is_some(){
                let  locker_ref =  locker.as_mut().unwrap().get_mut();
                let _ = match qos{
                    QosNative::AtLeastOnce => locker_ref.subscribe(topic, QoS::AtMostOnce),
                    QosNative::ExactlyOnce => locker_ref.subscribe(topic, QoS::ExactlyOnce),
                    QosNative::AtMostOnce  => locker_ref.subscribe(topic, QoS::AtMostOnce),
                };
            }
        }
    }
    pub fn exit(&self){
        if let Ok(mut locker) = self.exit_flag.lock(){
            *locker = true;
        }
        self.disconnect();
    }
    pub fn state_monitor(&self,sink:StreamSink<String>){
        loop{
            if let Ok(locker) = self.exit_flag.lock(){
                if *locker == true{
                    break;
                }
            }
            if let Ok(msg) =  self.rx.recv_timeout(std::time::Duration::from_millis(100)){
                println!("monitor msg:{:?}",msg);
                sink.add(msg);
            }
        }
        println!("return state_monitor");
    }
    pub fn disconnect(&self){
        if let Ok(mut locker) = self.client.lock(){
            if locker.is_some(){
                locker.as_mut().unwrap().get_mut().disconnect();
                println!("开始断开链接");
            }
        }
    }
    pub fn begin_receive(&self,sink:StreamSink<String>){
        println!("begin_receive");
        let mut first_connect = false;
        loop{
            if let Ok(mut locker) = self.connection.lock(){
                if locker.is_none(){
                    continue;
                }
                let locker_ref =  locker.as_mut().unwrap().get_mut();
                match locker_ref.recv_timeout(std::time::Duration::from_millis(100)){  //TODO! 读取超时时间，可以通过配置修改
                    Ok(event) =>{
                        match  event{
                            Ok(event) =>{
                                if first_connect == false{
                                    self.tx.send("connect_success".to_string());
                                    first_connect = true;
                                }
                                match event{
                                    Event::Incoming(Incoming::Publish(p)) => {
                                        println!("Received message: {:?}", p.payload);
                                        sink.add(String::from_utf8(p.payload.to_vec()).unwrap());
                                    },
                                    _ => {}
                                }
                            },
                            Err(error)=>{
                                println!("链接断开");
                                self.tx.send("connect_error".to_string());
                                break;
                                // match error{
                                //     ConnectionError::MqttState(state) =>{
                                //         println!("state=>{:?}",state.to_string());
                                //     },
                                //     _=>{
                                    
                                //     }
                                // }
                                //println!("error:{:?}",error);
                            }
                        }
                    },
                    _ =>{}  //TimeOut
                    // Err(error) =>{
                    //     println!("{:?}",error);
                    //   match error{
                    //     RecvTimeoutError::Disconnected =>{
                    //         println!("断开连接 from rust");
                    //         break; 
                    //     },
                    //     _ => {}
                    //   }  
                    // }
                }
            }
        }
        println!("end receive");
    }
    pub fn unsubscribe(&self,topic:String){
        if let Ok(mut locker) = self.client.lock(){
            if locker.is_some(){
                locker.as_mut().unwrap().get_mut().unsubscribe(topic);
            }
        }
    }
    pub fn publish(&self,topic:String,qos:QosNative,retain:bool,payload:String){
        println!("{:?}",payload);
        if let Ok(mut locker) = self.client.lock(){
            let locker_ref =  locker.as_mut().unwrap().get_mut();
            let _ = match qos{
                QosNative::AtLeastOnce => locker_ref.publish(topic, QoS::AtLeastOnce, retain, payload),
                QosNative::ExactlyOnce => locker_ref.publish(topic, QoS::ExactlyOnce, retain, payload),
                QosNative::AtMostOnce  => locker_ref.publish(topic, QoS::AtMostOnce, retain, payload)
            };
        }
    }
}
