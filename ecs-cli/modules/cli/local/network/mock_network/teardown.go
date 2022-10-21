// Copyright 2015-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"). You may
// not use this file except in compliance with the License. A copy of the
// License is located at
//
//     http://aws.amazon.com/apache2.0/
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.

// Code generated by MockGen. DO NOT EDIT.
// Source: github.com/aws/amazon-ecs-cli/ecs-cli/modules/cli/local/network (interfaces: LocalEndpointsStopper)

// Package mock_network is a generated GoMock package.
package mock_network

import (
	context "context"
	reflect "reflect"
	time "time"

	types "github.com/docker/docker/api/types"
	gomock "github.com/golang/mock/gomock"
)

// MockLocalEndpointsStopper is a mock of LocalEndpointsStopper interface
type MockLocalEndpointsStopper struct {
	ctrl     *gomock.Controller
	recorder *MockLocalEndpointsStopperMockRecorder
}

// MockLocalEndpointsStopperMockRecorder is the mock recorder for MockLocalEndpointsStopper
type MockLocalEndpointsStopperMockRecorder struct {
	mock *MockLocalEndpointsStopper
}

// NewMockLocalEndpointsStopper creates a new mock instance
func NewMockLocalEndpointsStopper(ctrl *gomock.Controller) *MockLocalEndpointsStopper {
	mock := &MockLocalEndpointsStopper{ctrl: ctrl}
	mock.recorder = &MockLocalEndpointsStopperMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockLocalEndpointsStopper) EXPECT() *MockLocalEndpointsStopperMockRecorder {
	return m.recorder
}

// ContainerRemove mocks base method
func (m *MockLocalEndpointsStopper) ContainerRemove(arg0 context.Context, arg1 string, arg2 types.ContainerRemoveOptions) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "ContainerRemove", arg0, arg1, arg2)
	ret0, _ := ret[0].(error)
	return ret0
}

// ContainerRemove indicates an expected call of ContainerRemove
func (mr *MockLocalEndpointsStopperMockRecorder) ContainerRemove(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "ContainerRemove", reflect.TypeOf((*MockLocalEndpointsStopper)(nil).ContainerRemove), arg0, arg1, arg2)
}

// ContainerStop mocks base method
func (m *MockLocalEndpointsStopper) ContainerStop(arg0 context.Context, arg1 string, arg2 *time.Duration) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "ContainerStop", arg0, arg1, arg2)
	ret0, _ := ret[0].(error)
	return ret0
}

// ContainerStop indicates an expected call of ContainerStop
func (mr *MockLocalEndpointsStopperMockRecorder) ContainerStop(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "ContainerStop", reflect.TypeOf((*MockLocalEndpointsStopper)(nil).ContainerStop), arg0, arg1, arg2)
}

// NetworkInspect mocks base method
func (m *MockLocalEndpointsStopper) NetworkInspect(arg0 context.Context, arg1 string, arg2 types.NetworkInspectOptions) (types.NetworkResource, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "NetworkInspect", arg0, arg1, arg2)
	ret0, _ := ret[0].(types.NetworkResource)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// NetworkInspect indicates an expected call of NetworkInspect
func (mr *MockLocalEndpointsStopperMockRecorder) NetworkInspect(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "NetworkInspect", reflect.TypeOf((*MockLocalEndpointsStopper)(nil).NetworkInspect), arg0, arg1, arg2)
}

// NetworkRemove mocks base method
func (m *MockLocalEndpointsStopper) NetworkRemove(arg0 context.Context, arg1 string) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "NetworkRemove", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// NetworkRemove indicates an expected call of NetworkRemove
func (mr *MockLocalEndpointsStopperMockRecorder) NetworkRemove(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "NetworkRemove", reflect.TypeOf((*MockLocalEndpointsStopper)(nil).NetworkRemove), arg0, arg1)
}
