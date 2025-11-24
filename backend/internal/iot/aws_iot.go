package iot

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/iotdataplane"
)

type AWSIoTClient struct {
	DataPlane *iotdataplane.IoTDataPlane
	Endpoint  string
}

func NewAWSIoTClient(endpoint, region string) (*AWSIoTClient, error) {
	if endpoint == "" {
		return nil, fmt.Errorf("AWS IoT endpoint is required")
	}

	// Load AWS credentials from environment
	sess, err := session.NewSession(&aws.Config{
		Region:      aws.String(region),
		Credentials: credentials.NewEnvCredentials(),
	})
	if err != nil {
		return nil, fmt.Errorf("failed to create AWS session: %w", err)
	}

	// Create IoT Data Plane client
	dataPlane := iotdataplane.New(sess, &aws.Config{
		Endpoint: aws.String(endpoint),
	})

	return &AWSIoTClient{
		DataPlane: dataPlane,
		Endpoint:  endpoint,
	}, nil
}

func (c *AWSIoTClient) PublishMessage(topic string, payload []byte) error {
	input := &iotdataplane.PublishInput{
		Topic:   aws.String(topic),
		Payload: payload,
	}

	_, err := c.DataPlane.Publish(input)
	return err
}

func (c *AWSIoTClient) GetThingShadow(thingName string) ([]byte, error) {
	input := &iotdataplane.GetThingShadowInput{
		ThingName: aws.String(thingName),
	}

	result, err := c.DataPlane.GetThingShadow(input)
	if err != nil {
		return nil, err
	}

	return result.Payload, nil
}

func (c *AWSIoTClient) UpdateThingShadow(thingName string, payload []byte) error {
	input := &iotdataplane.UpdateThingShadowInput{
		ThingName: aws.String(thingName),
		Payload:   payload,
	}

	_, err := c.DataPlane.UpdateThingShadow(input)
	return err
}

// LoadCertificate loads certificate files for MQTT connection
func LoadCertificate(certPath, keyPath, caPath string) (*tls.Config, error) {
	cert, err := tls.LoadX509KeyPair(certPath, keyPath)
	if err != nil {
		return nil, fmt.Errorf("failed to load certificate: %w", err)
	}

	caCert, err := os.ReadFile(caPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read CA certificate: %w", err)
	}

	caCertPool := x509.NewCertPool()
	if !caCertPool.AppendCertsFromPEM(caCert) {
		return nil, fmt.Errorf("failed to parse CA certificate")
	}

	return &tls.Config{
		Certificates: []tls.Certificate{cert},
		RootCAs:      caCertPool,
	}, nil
}
