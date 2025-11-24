package iot

import (
	"encoding/json"
	"log"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

type Handler struct {
	endpoint string
	client   mqtt.Client
}

func NewHandler(endpoint string) *Handler {
	return &Handler{
		endpoint: endpoint,
	}
}

func (h *Handler) Connect() error {
	opts := mqtt.NewClientOptions()
	opts.AddBroker(h.endpoint)
	opts.SetClientID("super-mobility-backend")
	opts.SetAutoReconnect(true)

	h.client = mqtt.NewClient(opts)
	if token := h.client.Connect(); token.Wait() && token.Error() != nil {
		return token.Error()
	}

	return nil
}

func (h *Handler) Subscribe(topic string) error {
	if token := h.client.Subscribe(topic, 1, h.messageHandler); token.Wait() && token.Error() != nil {
		return token.Error()
	}
	log.Printf("Subscribed to topic: %s", topic)
	return nil
}

func (h *Handler) messageHandler(client mqtt.Client, msg mqtt.Message) {
	var data map[string]interface{}
	if err := json.Unmarshal(msg.Payload(), &data); err != nil {
		log.Printf("Error parsing message: %v", err)
		return
	}

	log.Printf("Received message on %s: %+v", msg.Topic(), data)

	// TODO: Process vehicle data and store in database
	// TODO: Trigger AI analysis if needed
	// TODO: Send notifications if thresholds exceeded
}

func (h *Handler) Publish(topic string, payload interface{}) error {
	data, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	token := h.client.Publish(topic, 1, false, data)
	token.Wait()
	return token.Error()
}
