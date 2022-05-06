/*package MQTTfiles;

import java.util.UUID;

public class Subscriber {

    public static void main(String[] args){

        Mqtt5RxClient client = Mqtt5Client.builder()
                .identifier(UUID.randomUUID().toString())
                .serverHost("broker.hivemq.com")
                .buildRx();

// As we use the reactive API, the following line does not connect yet, but returns a reactive type.
// e.g. Single is something like a lazy and reusable future. Think of it as a source for the ConnAck message.
        Single<Mqtt5ConnAck> connAckSingle = client.connect();

// Same here: the following line does not subscribe yet, but returns a reactive type.
// FlowableWithSingle is a combination of the single SubAck message and a Flowable of Publish messages.
// A Flowable is an asynchronous stream that enables backpressure from the application over the client to the broker.
        FlowableWithSingle<Mqtt5Publish, Mqtt5SubAck> subAckAndMatchingPublishes = client.subscribeStreamWith()
                .topicFilter("a/b/c").qos(MqttQos.AT_LEAST_ONCE)
                .addSubscription().topicFilter("a/b/c/d").qos(MqttQos.EXACTLY_ONCE).applySubscription()
                .applySubscribe();

// The reactive types offer many operators that will not be covered here.
// Here we register callbacks to print messages when we received the CONNACK, SUBACK and matching PUBLISH messages.
        Completable connectScenario = connAckSingle
                .doOnSuccess(connAck -> System.out.println("Connected, " + connAck.getReasonCode()))
                .doOnError(throwable -> System.out.println("Connection failed, " + throwable.getMessage()))
                .ignoreElement();

        Completable subscribeScenario = subAckAndMatchingPublishes
                .doOnSingle(subAck -> System.out.println("Subscribed, " + subAck.getReasonCodes()))
                .doOnNext(publish -> System.out.println(
                        "Received publish" + ", topic: " + publish.getTopic() + ", QoS: " + publish.getQos() +
                                ", payload: " + new String(publish.getPayloadAsBytes())))
                .ignoreElements();

// Reactive types can be easily and flexibly combined
        connectScenario.andThen(subscribeScenario).blockingAwait();
    }
}
*/