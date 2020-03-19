1.部署两个版本的tomcat，版本v1对应8.0，版本v2对应8.5，都支持水平自动伸缩
2.默认4层负载均衡svc，在两个版本之间轮转请求
3.http请求逻辑流程
客户端->集群外部L4负载均衡->istio gateway-> istio virtualservice->istio destination->集群内部L4负载均衡->pod
涉及多级调用: pod->egress->ServiceEntry 或者 pod->集群内部L4负载均衡->其他pod
注意：整个过程并不需要kubernetes内置L7负载均衡ingress
4.熔断规则
5.限流规则
