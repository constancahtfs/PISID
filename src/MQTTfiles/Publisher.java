/*package MQTTfiles;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

public class Publisher {
    public static void main(String[] args){

        System.out.println("-----------");
        try {
            Mqtt5RxClient client = Mqtt5Client.builder()
                    .identifier(UUID.randomUUID().toString())
                    .serverHost("broker.hivemq.com")
                    .buildRx();

// As we use the reactive API, the following line does not connect yet, but returns a reactive type.
            Completable connectScenario = client.connect()
                    .doOnSuccess(connAck -> System.out.println("Connected, " + connAck.getReasonCode()))
                    .doOnError(throwable -> System.out.println("Connection failed, " + throwable.getMessage()))
                    .ignoreElement();

// Fake a stream of Publish messages with an incrementing number in the payload
            Flowable<Mqtt5Publish> messagesToPublish = Flowable.range(0, 10_000)
                    .map(i -> Mqtt5Publish.builder()
                            .topic("a/b/c")
                            .qos(MqttQos.AT_LEAST_ONCE)
                            .payload(("test " + i).getBytes())
                            .build())
                    // Emit 1 message only every 100 milliseconds
                    .zipWith(Flowable.interval(100, TimeUnit.MILLISECONDS), (publish, i) -> publish);

// As we use the reactive API, the following line does not publish yet, but returns a reactive type.
            Completable publishScenario = client.publish(messagesToPublish)
                    .doOnNext(publishResult -> System.out.println(
                            "Publish acknowledged: " + new String(publishResult.getPublish().getPayloadAsBytes())))
                    .ignoreElements();

// As we use the reactive API, the following line does not disconnect yet, but returns a reactive type.
            Completable disconnectScenario = client.disconnect().doOnComplete(() -> System.out.println("Disconnected"));

// Reactive types can be easily and flexibly combined
            connectScenario.andThen(publishScenario).andThen(disconnectScenario).blockingAwait();
        }
        catch(Exception ex){
            int adeus = 1;
        }
    }

}
*/