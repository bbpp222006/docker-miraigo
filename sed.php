<?php
/**
 * Created by IntelliJ IDEA.
 * User: scjtqs
 * Date: 2020-08-29
 * Time: 19:00
 */
//用于更新config.json
$file_name='/mirai/config.json';
$token=$_SERVER['TOKEN'];
$qq=intval($_SERVER['QQ']);
$password=$_SERVER['PASSWORD'];
$posturl=$_SERVER['POSTURL'];
$secret=$_SERVER['SECRET'];
$ws_enable=(($_SERVER['WS_REVERSE_SERVERS_ENABLE']===true) || (strtolower($_SERVER['WS_REVERSE_SERVERS_ENABLE'])!=='false' && !empty($_SERVER['WS_REVERSE_SERVERS_ENABLE'])))?true:false;
$str=file_get_contents($file_name);
$array=json_decode($str,true);
if(empty($array))
{
    exit(0);
}
$array['uin']=$qq;
$array['password']=$password;
$array['access_token']=$token;
$array['heartbeat_interval']=intval(5);
$array['http_config']['post_urls']=[$posturl=>$secret];
$array['http_config']['timeout']=1;
$array['ws_reverse_servers'][0]['enabled']=boolval($ws_enable);
$array['ws_reverse_servers'][0]['reverse_url']=$_SERVER['WS_REVERSE_URL'];
$array['ws_reverse_servers'][0]['reverse_api_url']=$_SERVER['WS_REVERSE_API_URL'];
$array['ws_reverse_servers'][0]['reverse_event_url']=$_SERVER['WS_REVERSE_EVENT_URL'];
if(empty($array['web_ui'])){
    $array['web_ui']=[
        "enable"=>true,
        "web_ui_port"=>9999,
        "user"=>"admin",
        "password"=>"admin"
    ];
}

file_put_contents($file_name,json_encode($array,JSON_PRETTY_PRINT));