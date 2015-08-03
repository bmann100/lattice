// This file was generated by counterfeiter
package fake_target_verifier

import (
	"sync"

	"github.com/cloudfoundry-incubator/lattice/ltc/config/dav_blob_store"
	"github.com/cloudfoundry-incubator/lattice/ltc/config/target_verifier"
)

type FakeTargetVerifier struct {
	VerifyTargetStub        func(name string) (up bool, auth bool, err error)
	verifyTargetMutex       sync.RWMutex
	verifyTargetArgsForCall []struct {
		name string
	}
	verifyTargetReturns struct {
		result1 bool
		result2 bool
		result3 error
	}
	VerifyBlobTargetStub        func(targetInfo dav_blob_store.Config) error
	verifyBlobTargetMutex       sync.RWMutex
	verifyBlobTargetArgsForCall []struct {
		targetInfo dav_blob_store.Config
	}
	verifyBlobTargetReturns struct {
		result1 error
	}
}

func (fake *FakeTargetVerifier) VerifyTarget(name string) (up bool, auth bool, err error) {
	fake.verifyTargetMutex.Lock()
	fake.verifyTargetArgsForCall = append(fake.verifyTargetArgsForCall, struct {
		name string
	}{name})
	fake.verifyTargetMutex.Unlock()
	if fake.VerifyTargetStub != nil {
		return fake.VerifyTargetStub(name)
	} else {
		return fake.verifyTargetReturns.result1, fake.verifyTargetReturns.result2, fake.verifyTargetReturns.result3
	}
}

func (fake *FakeTargetVerifier) VerifyTargetCallCount() int {
	fake.verifyTargetMutex.RLock()
	defer fake.verifyTargetMutex.RUnlock()
	return len(fake.verifyTargetArgsForCall)
}

func (fake *FakeTargetVerifier) VerifyTargetArgsForCall(i int) string {
	fake.verifyTargetMutex.RLock()
	defer fake.verifyTargetMutex.RUnlock()
	return fake.verifyTargetArgsForCall[i].name
}

func (fake *FakeTargetVerifier) VerifyTargetReturns(result1 bool, result2 bool, result3 error) {
	fake.VerifyTargetStub = nil
	fake.verifyTargetReturns = struct {
		result1 bool
		result2 bool
		result3 error
	}{result1, result2, result3}
}

func (fake *FakeTargetVerifier) VerifyBlobTarget(targetInfo dav_blob_store.Config) error {
	fake.verifyBlobTargetMutex.Lock()
	fake.verifyBlobTargetArgsForCall = append(fake.verifyBlobTargetArgsForCall, struct {
		targetInfo dav_blob_store.Config
	}{targetInfo})
	fake.verifyBlobTargetMutex.Unlock()
	if fake.VerifyBlobTargetStub != nil {
		return fake.VerifyBlobTargetStub(targetInfo)
	} else {
		return fake.verifyBlobTargetReturns.result1
	}
}

func (fake *FakeTargetVerifier) VerifyBlobTargetCallCount() int {
	fake.verifyBlobTargetMutex.RLock()
	defer fake.verifyBlobTargetMutex.RUnlock()
	return len(fake.verifyBlobTargetArgsForCall)
}

func (fake *FakeTargetVerifier) VerifyBlobTargetArgsForCall(i int) dav_blob_store.Config {
	fake.verifyBlobTargetMutex.RLock()
	defer fake.verifyBlobTargetMutex.RUnlock()
	return fake.verifyBlobTargetArgsForCall[i].targetInfo
}

func (fake *FakeTargetVerifier) VerifyBlobTargetReturns(result1 error) {
	fake.VerifyBlobTargetStub = nil
	fake.verifyBlobTargetReturns = struct {
		result1 error
	}{result1}
}

var _ target_verifier.TargetVerifier = new(FakeTargetVerifier)
