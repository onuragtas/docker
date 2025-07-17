FROM rabbitmq:3.10.25-management

RUN apt-get update && apt-get install -y curl unzip

RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.10.2/rabbitmq_delayed_message_exchange-3.10.2.ez > $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.10.2.ez

RUN chown rabbitmq:rabbitmq $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.10.2.ez

RUN rabbitmq-plugins enable rabbitmq_delayed_message_exchange