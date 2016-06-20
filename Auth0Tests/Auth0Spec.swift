// Auth0Spec.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Quick
import Nimble
import OHHTTPStubs

@testable import Auth0

private let ClientId = "CLIENT_ID"
private let Domain = "samples.auth0.com"

class Auth0Spec: QuickSpec {
    override func spec() {

        describe("endpoints") {

            it("should return authentication endpoint with clientId and domain") {
                let auth = Auth0.authentication(clientId: ClientId, domain: Domain)
                expect(auth).toNot(beNil())
                expect(auth.clientId) ==  ClientId
                expect(auth.url.absoluteString) == "https://\(Domain)"
            }


            it("should return authentication endpoint with domain url") {
                let domain = "https://mycustomdomain.com"
                let auth = Auth0.authentication(clientId: ClientId, domain: domain)
                expect(auth.url.absoluteString) == domain
            }

            it("should return management endopoint") {
                let management = Auth0.management(token: "token", domain: Domain)
                expect(management.token) == "token"
                expect(management.url.absoluteString) == "https://\(Domain)"
            }

            it("should return users endopoint") {
                let users = Auth0.users(token: "token", domain: Domain)
                expect(users.management.token) == "token"
                expect(users.management.url.absoluteString) == "https://\(Domain)"
            }

        }

        describe("plist loading") {

            let bundle = NSBundle(forClass: Auth0Spec.classForCoder())

            it("should return authentication endpoint with account from plist") {
                let auth = Auth0.authentication(bundle: bundle)
                expect(auth.url.absoluteString) == "https://samples.auth0.com"
                expect(auth.clientId) == "CLIENT_ID"
            }

            it("should return management endpoint with domain from plist") {
                let management = Auth0.management(token: "TOKEN", bundle: bundle)
                expect(management.url.absoluteString) == "https://samples.auth0.com"
            }

            it("should return users endpoint with domain from plist") {
                let users = Auth0.users(token: "TOKEN", bundle: bundle)
                expect(users.management.url.absoluteString) == "https://samples.auth0.com"
            }

        }
    }
}