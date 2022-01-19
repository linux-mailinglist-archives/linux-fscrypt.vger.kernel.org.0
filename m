Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE6493B0B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jan 2022 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354685AbiASNZQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jan 2022 08:25:16 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4432 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350184AbiASNZP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jan 2022 08:25:15 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jf5wV6qk1z67HKP;
        Wed, 19 Jan 2022 21:24:58 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 14:25:12 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Wed, 19 Jan 2022 14:25:12 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Antony Vennard <antony@vennard.ch>
CC:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>
Subject: RE: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Topic: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Index: AQHYBxWUAJoIvMeqLk2UYoD6PZRMZ6xnP9oAgAAHlwCAAfOkgIAAJTmAgAD7bXA=
Date:   Wed, 19 Jan 2022 13:25:12 +0000
Message-ID: <d71ea8ae51e1438c894b44b011f3efda@huawei.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
 <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
 <079f10b9-060b-3a36-2224-fa1b483cbad5@vennard.ch>
 <YedHR93wPLS/JEsE@sol.localdomain>
In-Reply-To: <YedHR93wPLS/JEsE@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.214.59]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

PiBGcm9tOiBFcmljIEJpZ2dlcnMgW21haWx0bzplYmlnZ2Vyc0BrZXJuZWwub3JnXQ0KPiBTZW50
OiBXZWRuZXNkYXksIEphbnVhcnkgMTksIDIwMjIgMTI6MDQgQU0NCj4gT24gVHVlLCBKYW4gMTgs
IDIwMjIgYXQgMDk6NTA6MjFQTSArMDEwMCwgQW50b255IFZlbm5hcmQgd3JvdGU6DQo+ID4NCj4g
PiBIaSBBbGwsDQo+ID4NCj4gPiBPbiAxNy8wMS8yMDIyIDE2OjAyLCBKYW1lcyBCb3R0b21sZXkg
d3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjItMDEtMTcgYXQgMTU6MzQgKzAxMDAsIEphc29uIEEu
IERvbmVuZmVsZCB3cm90ZToNCj4gPiA+ID4gSGksDQo+ID4gPiA+DQo+ID4gPiA+IFdoaWxlIGl0
IGxvb2tzIGxpa2UgeW91IHB1dCBhIGxvdCBvZiB3b3JrIGludG8gdGhpcyBwYXRjaHNldCwgSSB0
aGluaw0KPiA+ID4gPiB0aGUgZ2VuZXJhbCBpZGVhIG9mIGFkZGluZyBQR1AgKnRvIHRoZSBrZXJu
ZWwqIGlzIGEgcHJldHR5IGRhdW50aW5nDQo+ID4gPiA+IHByb3Bvc2l0aW9uLiBUaGUgZ2VuZXJh
bCBjb25zZW5zdXMgaW4gdGhlIGNyeXB0byBlbmdpbmVlcmluZyB3b3JsZCBpcw0KPiA+ID4gPiB0
aGF0IFBHUCBvdWdodCB0byBiZSBvbiBpdHMgd2F5IG91dC4gV2UgZGVmaW5pdGVseSBkb24ndCB3
YW50IHRvDQo+ID4gPiA+IHBlcnBldHVhdGUgdGhpcyBwcm9qZWN0LW9uLWxpZmUtc3VwcG9ydCBp
bnRvIHRoZSBwZXJtYW5lbmNlIG9mIGtlcm5lbA0KPiA+ID4gPiBjb2RlLiBTb21lIHF1aWNrIEdv
b2dsZSBzZWFyY2hlcyB3aWxsIHJldmVhbCBhIGxpdGFueSBvZiBibG9nIHBvc3RzDQo+ID4gPiA+
IHRvIHRoZSB0dW5lIG9mLCAid2h5IG9oIHdoeSBhcmUgcGVvcGxlIHN0aWxsIHVzaW5nIHRoaXM/
IiBIZXJlJ3Mgb25lDQo+ID4gPiA+IGZyb20gMjAxOToNCj4gPiA+ID4gaHR0cHM6Ly9sYXRhY29y
YS5taWNyby5ibG9nLzIwMTkvMDcvMTYvdGhlLXBncC1wcm9ibGVtLmh0bWwgLiBJDQo+ID4gPiA+
IHRoaW5rIHRoZXNlIGFyZSBhcmd1bWVudHMgdG8gdGFrZSBzZXJpb3VzbHkuIEFuZCBldmVuIGlm
IHlvdSBkaXNhZ3JlZQ0KPiA+ID4gPiB3aXRoIHNvbWUgcGFydHMsIHlvdSBtYXkgd2FudCB0byBj
b25zaWRlciB3aGV0aGVyIHRoZSByZW1haW5pbmcgcGFydHMNCj4gPiA+ID4gd2FycmFudCBhIGJp
dCBvZiBwYXVzZSBiZWZvcmUgYWRkaW5nIHRoaXMgdG8gdGhlIGtlcm5lbCBhbmQNCj4gPiA+ID4g
cGVycGV0dWF0aW5nIFBHUCdzIGRlc2lnbiBmdXJ0aGVyLg0KPiA+DQo+ID4gU28gd2hpbGUgSSB1
bmRlcnN0YW5kIHdoeSB0aGlzIGlzIGJlaW5nIHByb3Bvc2VkIGFuZCBjbGVhcmx5IGVmZm9ydCBo
YXMgZ29uZQ0KPiA+IGludG8gaXQsIEkgYWxzbyB0aGluayBpdCBpcyBub3QgdGhlIHJpZ2h0IGFw
cHJvYWNoLiBJdCBzZWVtcyB0aGlzIHByb3Bvc2FsDQo+ID4gaXMgdG8gaW5jbHVkZSBhIGZ1bGwg
UEdQIHBhY2tldCBwYXJzZXIgYW5kIHZlcmlmaWNhdGlvbiBsb2dpYyBpbiB0aGUga2VybmVsDQo+
ID4gYXMgYW4gZXF1aXZhbGVudCB0byBhbGxvdyBQR1Agc2lnbmF0dXJlcyB0byBiZSBzdWJtaXR0
ZWQgdmlhDQo+ID4gRlNfSU9DX0VOQUJMRV9WRVJJVFk6DQo+ID4NCj4gPiAiRlNfSU9DX0VOQUJM
RV9WRVJJVFkgYWNjZXB0cyBhIHBvaW50ZXIgdG8gYSBQS0NTIzcgZm9ybWF0dGVkIGRldGFjaGVk
DQo+ID4gc2lnbmF0dXJlIGluIERFUiBmb3JtYXQgb2YgdGhlIGZpbGXigJlzIGZzLXZlcml0eSBk
aWdlc3QuIg0KPiA+DQo+IA0KPiBJdCdzIHdvcnRoIG5vdGluZyB0aGF0IGlmIGZzLXZlcml0eSBi
dWlsdC1pbiBzaWduYXR1cmVzIGFyZSB1c2VkLCBhIHRydXN0ZWQNCj4gdXNlcnNwYWNlIHByb2dy
YW0gaXMgc3RpbGwgcmVxdWlyZWQgdG8gZGV0ZXJtaW5lIGFuZCBlbmZvcmNlIHRoZSBwb2xpY3kg
b2Ygd2hpY2gNCj4gZmlsZXMgYXJlIHJlcXVpcmVkIHRvIGJlIHNpZ25lZC4gIFRoZSBrZXJuZWwg
b25seSBoYW5kbGVzIHRoZSBhY3R1YWwgc2lnbmF0dXJlDQo+IHZlcmlmaWNhdGlvbi4gIFRoaXMg
d2FzIGJhc2ljYWxseSBhIHByb29mLW9mLWNvbmNlcHQgd2hpY2ggcmV1c2VkIHRoZSBrZXJuZWwn
cw0KPiBtb2R1bGUgc2lnbmF0dXJlIHZlcmlmaWNhdGlvbiBjb2RlICh3aGljaCBoYXBwZW5zIHRv
IHVzZSBQS0NTIzcpLg0KDQpKdXN0IHRvIHNob3cgaG93IHRoZSBmc3Zlcml0eSBjb2RlIHdpbGwg
bG9vayBsaWtlIGFmdGVyIGFkZGluZyBzdXBwb3J0DQpmb3IgUEdQIHNpZ25hdHVyZXM6DQoNCisg
ICAgICAgc3dpdGNoICh2aS0+dHlwZSkgew0KKyAgICAgICBjYXNlIFBLRVlfSURfUEtDUzc6DQor
ICAgICAgICAgICAgICAgZXJyID0gdmVyaWZ5X3BrY3M3X3NpZ25hdHVyZShkLCBzaXplb2YoKmQp
ICsgaGFzaF9hbGctPmRpZ2VzdF9zaXplLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc2lnbmF0dXJlLCBzaWdfc2l6ZSwgZnN2ZXJpdHlfa2V5cmluZywNCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFZFUklGWUlOR19VTlNQ
RUNJRklFRF9TSUdOQVRVUkUsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBOVUxMLCBOVUxMKTsNCisgICAgICAgICAgICAgICBicmVhazsNCisgICAgICAgY2Fz
ZSBQS0VZX0lEX1BHUDoNCisgICAgICAgICAgICAgICBlcnIgPSB2ZXJpZnlfcGdwX3NpZ25hdHVy
ZShkLCBzaXplb2YoKmQpICsgaGFzaF9hbGctPmRpZ2VzdF9zaXplLA0KKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpZ25hdHVyZSwgc2lnX3NpemUsIGZzdmVyaXR5
X2tleXJpbmcsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgVkVS
SUZZSU5HX1VOU1BFQ0lGSUVEX1NJR05BVFVSRSwNCisgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBOVUxMLCBOVUxMKTsNCisgICAgICAgICAgICAgICBicmVhazsNCisg
ICAgICAgZGVmYXVsdDoNCisgICAgICAgICAgICAgICBlcnIgPSAtRU9QTk9UU1VQUDsNCisgICAg
ICAgfQ0KDQpBcyB5b3UgY2FuIHNlZSwgdGhlIGNoYW5nZSB3aWxsIGJlIHN0cmFpZ2h0Zm9yd2Fy
ZC4NCg0KT24gdXNlciBzcGFjZSBzaWRlLCBJIHBsYW4gdG8gYWRkIHRoZSBjYXBhYmlsaXR5IHRv
IGZzdmVyaXR5LXV0aWxzDQp0byBwcm9kdWNlIGEgUEdQIHNpZ25hdHVyZSB3aXRoIHRoZSBHUEcg
a2V5IHBhc3NlZCBieSBycG1zaWduLg0KDQo+IEknZCBlbmNvdXJhZ2UgbmV3IHVzZXJzIHRvIGVp
dGhlciBnbyBhbGwtaW4gb24gYSB1c2Vyc3BhY2Ugc29sdXRpb24sIHVzaW5nIGENCj4gdHJ1c3Rl
ZCB1c2Vyc3BhY2UgcHJvZ3JhbSB0byB2ZXJpZnkgc2lnbmF0dXJlcyBvZiBmcy12ZXJpdHkgZmls
ZSBkaWdlc3RzOw0KPiAqb3IqIGdvIGFsbC1pbiBvbiBhbiBpbi1rZXJuZWwgc29sdXRpb24sIHVz
aW5nIHRoZSBJTUEgc3VwcG9ydCBmb3IgZnMtdmVyaXR5DQo+IHdoaWNoIE1pbWkgWm9oYXIgaXMg
d29ya2luZyBvbi4gIEEgdXNlcnNwYWNlIHNvbHV0aW9uIGNvdWxkIHVzZSBhIHNpbXBsZQ0KDQpQ
cm9iYWJseSwgdGhlcmUgaXMgYWxzbyB0aGUgdGhpcmQgb3B0aW9uIG9mIGFuIExTTSAoc3VjaCBh
cyBJUEUpIHRoYXQgZ2V0cw0KZnJvbSBmc3Zlcml0eSB0aGUgaW5mb3JtYXRpb24gaWYgdGhlIHNp
Z25hdHVyZSB3YXMgdmFsaWRhdGVkLCBhbmQgZGVjaWRlDQpkZXBlbmRpbmcgb24gYSBwb2xpY3ku
IEkgd291bGQgYWxzbyBleHBvc2UgdGhlIGluZm9ybWF0aW9uIGFib3V0IHRoZQ0KcmVzdHJpY3Rp
b24gaW1wb3NlZCBvbiB0aGUga2V5cmluZyBmcm9tIHdoaWNoIHRoZSBrZXkgdXNlZCB0byB2ZXJp
ZnkNCnRoZSBzaWduYXR1cmUgd2FzIGZvdW5kLg0KDQpNYXliZSBJTUEgY291bGQgdXNlIHRoaXMg
YXBwcm9hY2ggdG9vLCB3aGljaCB3b3VsZCBhdm9pZCB0aGUgbmVlZA0Kb2YgaW50cm9kdWNpbmcg
YW5vdGhlciBzaWduYXR1cmUgZm9ybWF0LiBJZiB0aGF0IGlzIGRlc2lyZWQsIHlvdSBtaWdodA0K
d2FudCB0byBjb29yZGluYXRlIHdpdGggdGhlIGF1dGhvcnMgb2YgYSBGZWRvcmEgZmVhdHVyZToN
Cg0KaHR0cHM6Ly9mZWRvcmFwcm9qZWN0Lm9yZy93aWtpL0NoYW5nZXMvRnNWZXJpdHlSUE0NCg0K
d2hpY2gsIGFzIGZhciBhcyBJIGtub3csIHBsYW4gdG8gdXNlIHRoZSBzaWduYXR1cmUgZm9ybWF0
IGFscmVhZHkNCnVwc3RyZWFtZWQuDQoNClRoYW5rcw0KDQpSb2JlcnRvDQoNCkhVQVdFSSBURUNI
Tk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3Rvcjog
TGkgUGVuZywgWmhvbmcgUm9uZ2h1YQ0KDQo+IHNpZ25hdHVyZSBmb3JtYXQsIHVzaW5nIGEgbW9k
ZXJuIGFsZ29yaXRobSBzdWNoIGFzIEVkMjU1MTkuICBJTUEgdXNlcyBhIHNpbXBsZQ0KPiBzaWdu
YXR1cmUgZm9ybWF0IHRvbywgdGhvdWdoIGl0IHVzZXMgYSBjb21wbGV4IGZvcm1hdCAoWC41MDkp
IGZvciBwdWJsaWMga2V5cy4NCj4gDQo+IC0gRXJpYw0K
