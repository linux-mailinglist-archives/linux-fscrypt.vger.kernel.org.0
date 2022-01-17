Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1D1490B4C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jan 2022 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbiAQPVo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jan 2022 10:21:44 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4422 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiAQPVo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jan 2022 10:21:44 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JcwWf25yVz6F8yG;
        Mon, 17 Jan 2022 23:17:50 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 17 Jan 2022 16:21:41 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Mon, 17 Jan 2022 16:21:41 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: RE: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Topic: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Index: AQHYBxWUAJoIvMeqLk2UYoD6PZRMZ6xnP9oAgAASNCA=
Date:   Mon, 17 Jan 2022 15:21:41 +0000
Message-ID: <887a1e46cd6f4c02a6530a15f00e8eb8@huawei.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
In-Reply-To: <YeV+jkGg6mpQdRID@zx2c4.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

PiBGcm9tOiBKYXNvbiBBLiBEb25lbmZlbGQgW21haWx0bzpKYXNvbkB6eDJjNC5jb21dDQo+IFNl
bnQ6IE1vbmRheSwgSmFudWFyeSAxNywgMjAyMiAzOjM1IFBNDQo+IEhpLA0KPiANCj4gV2hpbGUg
aXQgbG9va3MgbGlrZSB5b3UgcHV0IGEgbG90IG9mIHdvcmsgaW50byB0aGlzIHBhdGNoc2V0LCBJ
IHRoaW5rDQo+IHRoZSBnZW5lcmFsIGlkZWEgb2YgYWRkaW5nIFBHUCAqdG8gdGhlIGtlcm5lbCog
aXMgYSBwcmV0dHkgZGF1bnRpbmcNCj4gcHJvcG9zaXRpb24uIFRoZSBnZW5lcmFsIGNvbnNlbnN1
cyBpbiB0aGUgY3J5cHRvIGVuZ2luZWVyaW5nIHdvcmxkIGlzDQo+IHRoYXQgUEdQIG91Z2h0IHRv
IGJlIG9uIGl0cyB3YXkgb3V0LiBXZSBkZWZpbml0ZWx5IGRvbid0IHdhbnQgdG8NCj4gcGVycGV0
dWF0ZSB0aGlzIHByb2plY3Qtb24tbGlmZS1zdXBwb3J0IGludG8gdGhlIHBlcm1hbmVuY2Ugb2Yg
a2VybmVsDQo+IGNvZGUuIFNvbWUgcXVpY2sgR29vZ2xlIHNlYXJjaGVzIHdpbGwgcmV2ZWFsIGEg
bGl0YW55IG9mIGJsb2cgcG9zdHMgdG8NCj4gdGhlIHR1bmUgb2YsICJ3aHkgb2ggd2h5IGFyZSBw
ZW9wbGUgc3RpbGwgdXNpbmcgdGhpcz8iIEhlcmUncyBvbmUgZnJvbQ0KPiAyMDE5OiBodHRwczov
L2xhdGFjb3JhLm1pY3JvLmJsb2cvMjAxOS8wNy8xNi90aGUtcGdwLXByb2JsZW0uaHRtbCAuIEkN
Cj4gdGhpbmsgdGhlc2UgYXJlIGFyZ3VtZW50cyB0byB0YWtlIHNlcmlvdXNseS4gQW5kIGV2ZW4g
aWYgeW91IGRpc2FncmVlDQo+IHdpdGggc29tZSBwYXJ0cywgeW91IG1heSB3YW50IHRvIGNvbnNp
ZGVyIHdoZXRoZXIgdGhlIHJlbWFpbmluZyBwYXJ0cw0KPiB3YXJyYW50IGEgYml0IG9mIHBhdXNl
IGJlZm9yZSBhZGRpbmcgdGhpcyB0byB0aGUga2VybmVsIGFuZCBwZXJwZXR1YXRpbmcNCj4gUEdQ
J3MgZGVzaWduIGZ1cnRoZXIuDQoNCkhpIEphc29uDQoNCnRoYW5rcyBhIGxvdCBmb3IgdGhlIGFk
ZGl0aW9uYWwgaW5mb3JtYXRpb24uIFRoZXkgY291bGQNCm1ha2UgcGVvcGxlIG1vcmUgYXdhcmUg
b2YgdGhlIHJpc2tzIHNvIHRoYXQgdGhleSB0cmFuc2l0aW9uDQp0byBtb3JlIHNlY3VyZSBzY2hl
bWVzLg0KDQpUaGUgcHJvYmxlbSBpcyB0aGF0IEkgZG9uJ3Qgc2VlIHRoYXQgdHJhbnNpdGlvbiBj
b21pbmcgc29vbi4NClRyYW5zaXRpb24gZnJvbSBQR1AgdG8gYW5vdGhlciBzY2hlbWUgd291bGQg
cmVxdWlyZSBMaW51eA0KZGlzdHJpYnV0aW9uIHZlbmRvcnMgdG8gZG8gYW4gaHVnZSBhbW91bnQg
b2Ygd29yay4gSXQgY291bGQNCnByb2JhYmx5IHRha2UgeWVhcnMgYmVmb3JlIHRoYXQgdHJhbnNp
dGlvbiBvY2N1cnMuDQoNCk1vcmUgc3BlY2lmaWNhbGx5LCB0aGUgZmlyc3QgdGFzayB3b3VsZCBi
ZSB0byBtb2RpZnkgaG93DQpSUE1zIGFyZSBzaWduZWQgKGFuZCB0aHVzIGhvdyB0aGV5IGFyZSB2
ZXJpZmllZCkuIFRoZSBzZWNvbmQNCnRhc2sgd291bGQgYmUgdG8gaGF2ZSBhIGRpZmZlcmVudCB3
YXkgdG8gY2VydGlmeSB0aGUgcHVibGljIGtleS4NCkxhc3RseSwgTGludXggZGlzdHJpYnV0aW9u
IHZlbmRvcnMgd291bGQgaGF2ZSB0byBjaGFuZ2UgdGhlaXINCmJ1aWxkaW5nIGluZnJhc3RydWN0
dXJlIHRvIHVzZSB0aGUgbmV3IGNlcnRpZmllZCBrZXksIGEgbmV3DQp2ZXJzaW9uIG9mIHRoZSBy
cG0gcGFja2FnZSBtYW5hZ2VyIHdoaWNoIHRha2VzIGFzIGlucHV0DQp0aGUgbmV3IGtleSwgcHJv
ZHVjZXMgYSBkaWZmZXJlbnQgdHlwZSBvZiBzaWduYXR1cmUgYW5kIGVtYmVkcw0KaXQgaW4gdGhl
IFJQTSBoZWFkZXIuDQoNCkluIHRoaXMgZGlzY3Vzc2lvbjoNCg0KaHR0cHM6Ly9saXN0cy5mZWRv
cmFwcm9qZWN0Lm9yZy9hcmNoaXZlcy9saXN0L2RldmVsQGxpc3RzLmZlZG9yYXByb2plY3Qub3Jn
L3RocmVhZC9KRTJIR0xKTUxFS1VKVzNZQlA2TVFKV1A0M0NTVEM1Ny8NCg0KcGVvcGxlIHdlcmUg
Y29uY2VybmVkIGFib3V0IHRoZSBsaWZlY3ljbGUgb2YgdGhlIHNlY29uZGFyeQ0Ka2V5IHVzZWQg
Zm9yIGZzdmVyaXR5IHNpZ25hdHVyZXMuIExpa2VseSwgY29tcGxldGVseSByZXBsYWNpbmcNCnRo
ZSBrZXkgaW5mcmFzdHJ1Y3R1cmUgd291bGQgcmFpc2UgZXZlbiBiaWdnZXIgY29uY2VybnMuDQoN
ClRoZSBhaW0gb2YgdGhpcyBwYXRjaCBzZXQgaXMgdG8gbWFrZSBzb21lIHNlY3VyaXR5IGZlYXR1
cmVzDQphdmFpbGFibGUgaW4gYSBzaG9ydCB0aW1lLCBieSBzaWduaWZpY2FudGx5IHJlZHVjaW5n
IHRoZSBidXJkZW4NCm9mIExpbnV4IGRpc3RyaWJ1dGlvbiB2ZW5kb3JzIGZvciBtYW5hZ2luZyB0
aG9zZSBzZWN1cml0eQ0KZmVhdHVyZXMuIEkgbWVudGlvbmVkIGZzdmVyaXR5LCBidXQgbXkgcHJp
bWFyeSB1c2UgY2FzZSB3b3VsZA0KYmUgZm9yIERJR0xJTSAoZXh0cmFjdCByZWZlcmVuY2UgdmFs
dWVzIGZvciBmaWxlIGRpZ2VzdHMgZnJvbQ0KUlBNIGhlYWRlcnMgYW5kIHVzZSB0aGVtIGZvciBJ
TUEgbWVhc3VyZW1lbnQgb3IgYXBwcmFpc2FsKS4NCg0KVGhlIG1haW4gYWR2YW50YWdlIG9mIHRo
aXMgcGF0Y2ggc2V0LCBhdCBsZWFzdCBmb3IgRElHTElNLCBpcw0KdGhhdCBpdCBjb21wbGV0ZWx5
IHJlbW92ZXMgdGhlIG5lZWQgb2YgY2hhbmdpbmcgdGhlIGJ1aWxkaW5nDQppbmZyYXN0cnVjdHVy
ZS4gVG8gc2hvdyB0aGUgRElHTElNIGJlbmVmaXRzLCBJIHJldHJvZml0dGVkIHR3bw0KYWxyZWFk
eSByZWxlYXNlZCBMaW51eCBkaXN0cmlidXRpb25zIChGZWRvcmEgMzQgYW5kIG9wZW5TVVNFDQpM
ZWFwIDE1LjMpIHdpdGggRElHTElNIGFuZCB0aGUgbmVjZXNzYXJ5IGNoYW5nZXMgaW4gSU1BLCBz
bw0KdGhhdCB0aGV5IHByZXZlbnQgdGhlIGV4ZWN1dGlvbiBvZiBiaW5hcmllcyBhbmQgc2hhcmVk
IGxpYnJhcmllcw0Kd2hpY2ggd2VyZSBub3QgcmVsZWFzZWQgYnkgdGhlIGRpc3RyaWJ1dGlvbiAo
dGhlIG1lY2hhbmlzbSBpcw0KY29tcGxldGVseSBjb25maWd1cmFibGUgYnkgdGhlIHVzZXIgdG8g
dHJ1c3QgaGlzIGJpbmFyaWVzLA0KaWYgaGUgd2lzaGVzIHRvKS4gSWYgeW91IGFyZSBpbnRlcmVz
dGVkLCBoZXJlIGlzIHRoZSBsaW5rIG9mIHRoZQ0KZGVtbyBJIGRldmVsb3BlZDoNCg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW50ZWdyaXR5LzQ4Y2Q3MzdjNTA0ZDQ1MjA4Mzc3ZGFh
MjdkNjI1NTMxQGh1YXdlaS5jb20vDQoNCklmIGluIHRoZSBmdXR1cmUgdGhlIHRyYW5zaXRpb24g
ZnJvbSBQR1AgdG8gYW5vdGhlciBzY2hlbWUNCm9jY3Vycywgc3VwcG9ydCBmb3IgUEdQIGtleXMg
YW5kIHNpZ25hdHVyZXMgY2FuIGJlIHN0aWxsDQpkZXByZWNhdGVkLg0KDQpSb2JlcnRvDQoNCkhV
QVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBE
aXJlY3RvcjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQ0KDQo+IElmIHlvdSdyZSBsb29raW5nIGZv
ciBhIHNpbXBsZSBzaWduYXR1cmUgbWVjaGFuaXNtIHRvIHJlcGxhY2UgdGhlIHVzZSBvZg0KPiBY
LjUwOSBhbmQgYWxsIG9mIHRoYXQgaW5mcmFzdHJ1Y3R1cmUsIG1heSBJIHN1Z2dlc3QganVzdCBj
b21pbmcgdXAgd2l0aA0KPiBzb21ldGhpbmcgc2ltcGxlIHVzaW5nIGVkMjU1MTksIHNpbWlsYXIg
dG8gc2lnbmlmeSBvciBtaW5pc2lnbj8gVmVyeQ0KPiBtaW5pbWFsIGNvZGUgaW4gdGhlIGtlcm5l
bCwgaW4gdXNlcnNwYWNlLCBhbmQgdmVyeSBmZXcgbW92aW5nIHBhcnRzIHRvDQo+IGJyZWFrLg0K
PiANCj4gSmFzb24NCg==
