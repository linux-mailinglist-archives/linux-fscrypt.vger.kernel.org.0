Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E048C0CF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jan 2022 10:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351971AbiALJQ0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 Jan 2022 04:16:26 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4403 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbiALJQ0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 Jan 2022 04:16:26 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYhgg0J3Cz685HY;
        Wed, 12 Jan 2022 17:13:35 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 10:16:23 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.020;
 Wed, 12 Jan 2022 10:16:23 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
CC:     "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Topic: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Thread-Index: AQHYBxWUAJoIvMeqLk2UYoD6PZRMZ6xeNfyAgADgBLA=
Date:   Wed, 12 Jan 2022 09:16:22 +0000
Message-ID: <b37f9c0e9bf941f0b778c6949538835d@huawei.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <ab29dd6f-1301-e012-8898-9c739ca511a3@maciej.szmigiero.name>
In-Reply-To: <ab29dd6f-1301-e012-8898-9c739ca511a3@maciej.szmigiero.name>
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

PiBGcm9tOiBNYWNpZWogUy4gU3ptaWdpZXJvIFttYWlsdG86bWFpbEBtYWNpZWouc3ptaWdpZXJv
Lm5hbWVdDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMTEsIDIwMjIgOTozMyBQTQ0KPiBPbiAx
MS4wMS4yMDIyIDE5OjAzLCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+IFN1cHBvcnQgZm9yIFBH
UCBrZXlzIGFuZCBzaWduYXR1cmVzIHdhcyBwcm9wb3NlZCBieSBEYXZpZCBsb25nIHRpbWUgYWdv
LA0KPiA+IGJlZm9yZSB0aGUgZGVjaXNpb24gb2YgdXNpbmcgUEtDUyM3IGZvciBrZXJuZWwgbW9k
dWxlcyBzaWduYXR1cmVzDQo+ID4gdmVyaWZpY2F0aW9uIHdhcyBtYWRlLiBBZnRlciB0aGF0LCB0
aGVyZSBoYXMgYmVlbiBub3QgZW5vdWdoIGludGVyZXN0IHRvDQo+ID4gc3VwcG9ydCBQR1AgdG9v
Lg0KPiA+DQo+ID4gTGF0ZWx5LCB3aGVuIGRpc2N1c3NpbmcgYSBwcm9wb3NhbCBvZiBpbnRyb2R1
Y2luZyBmc3Zlcml0eSBzaWduYXR1cmVzIGluDQo+ID4gRmVkb3JhIFsxXSwgZGV2ZWxvcGVycyBl
eHByZXNzZWQgdGhlaXIgcHJlZmVyZW5jZSBvbiBub3QgaGF2aW5nIGEgc2VwYXJhdGUNCj4gPiBr
ZXkgZm9yIHNpZ25pbmcsIHdoaWNoIHdvdWxkIGNvbXBsaWNhdGUgdGhlIG1hbmFnZW1lbnQgb2Yg
dGhlIGRpc3RyaWJ1dGlvbi4NCj4gPiBUaGV5IHdvdWxkIGJlIG1vcmUgaW4gZmF2b3Igb2YgdXNp
bmcgdGhlIHNhbWUgUEdQIGtleSwgY3VycmVudGx5IHVzZWQgZm9yDQo+ID4gc2lnbmluZyBSUE0g
aGVhZGVycywgYWxzbyBmb3IgZmlsZS1iYXNlZCBzaWduYXR1cmVzIChub3Qgb25seSBmc3Zlcml0
eSwgYnV0DQo+ID4gYWxzbyBJTUEgb25lcykuDQo+IA0KPiBBcmVuJ3QgUEdQIGtleXMgc2ltcGx5
IFJTQSAvIEVDQyAvIEVkRFNBIGtleXMgd2l0aCBhZGRpdGlvbmFsIG1ldGFkYXRhPw0KPiBDYW4n
dCB0aGV5IGJlIHVud3JhcHBlZCBmcm9tIHRoZWlyIChjb21wbGV4KSBQR1AgZm9ybWF0IGluIHVz
ZXJzcGFjZSBhbmQNCj4gbG9hZGVkIHJhdyBpbnRvIHRoZSBrZXJuZWwsIGluIGEgc2ltaWxhciB3
YXkgYXMgdGhleSBhcmUgc29tZXRpbWVzIHVzZWQNCj4gZm9yIFNTSCBhdXRoZW50aWNhdGlvbj8N
Cg0KUHJvYmFibHksIHRoaXMgd291bGQgYmUgcG9zc2libGUgYnkgaW50cm9kdWNpbmcgYSBuZXcg
YXN5bW1ldHJpYw0Ka2V5IHN1YnR5cGUgcGFyc2luZyBQR1Aga2V5cyBhbmQgc2lnbmF0dXJlcyBp
biBhIG1vcmUgc2ltcGxlIGZvcm1hdCwNCmFmdGVyIGNvbnZlcnNpb24gYnkgdXNlciBzcGFjZS4g
QnV0IHN0aWxsLCBhIHBhcnNlciB3b3VsZCBiZSByZXF1aXJlZC4NClRvIGJlIGhvbmVzdCwgSSB3
b3VsZCBwcmVmZXIgdG8gaW1wbGVtZW50IChhY3R1YWxseSBEYXZpZCBkaWQpIGENCnBhcnNlciBm
b2xsb3dpbmcgYW4gUkZDLCB0aGFuIGRldmVsb3BpbmcgYSBuZXcgb25lLg0KDQo+IFRoaXMgd2ls
bCBzYXZlIHVzIGZyb20gaGF2aW5nIHRvIGFkZCBjb21wbGV4IHBhcnNlcnMgKGEgd2VsbC1rbm93
biBzb3VyY2UNCj4gb2YgYnVncykgaW50byB0aGUga2VybmVsIC0gSSBndWVzcyB0aGVyZSBhcmVu
J3QgYW55IHBsYW5zIHRvIGFkZCBhbg0KPiBpbi1rZXJuZWwgUEdQIFdlYiBvZiBUcnVzdCBpbXBs
ZW1lbnRhdGlvbi4NCg0KSSBleHRlbnNpdmVseSB0ZXN0ZWQgdGhlIGltcGxlbWVudGF0aW9uIHdp
dGggYW4gYWQtaG9jIGZhdWx0IGluamVjdG9yLA0KdG8gc2VlIGlmIHRoZSBjb2RlIGNhbiBjb3Jy
ZWN0bHkgaGFuZGxlIGVycm9ycy4gSSBhbHNvIGRldmVsb3BlZCBhDQpmdXp6ZXIgdG8gY29ycnVw
dCB0aGUgZGF0YSBiZWZvcmUgaXQgaXMgcmVhZCBieSB0aGUga2VybmVsLiBGaW5hbGx5LA0KSSBj
aGVja2VkIHRoYXQgdGhlcmUgYXJlIG5vdCBtZW1vcnkgbGVha3MuIEJ1dCBJIGFncmVlLCB0aGVy
ZSBjb3VsZA0Kc3RpbGwgYmUgYnVncy4NCg0KSWYgeW91IG1lYW4gdGhhdCBhIGtleSBjYW4gYmUg
YWRkZWQgdG8gdGhlIGtlcm5lbCBpZiBpcyB2b3VjaGVkIGZvcg0KYnkgYW5vdGhlciBrZXkgaW4g
dGhlIGJ1aWx0LWluIGtleXJpbmcsIEkgYWN0dWFsbHkgaW1wbGVtZW50ZWQgdGhpcw0KKHdhcyBt
aXNzaW5nIGluIHRoZSBvcmlnaW5hbCBpbXBsZW1lbnRhdGlvbikuIFNvbWUga2V5cmluZ3MsIGUu
Zy4gLmltYSwNCmhhdmUgdGhpcyByZXN0cmljdGlvbi4NCg0KVGhlIHdheSB0aGlzIHdvcmtzIGlz
IHRoYXQsIHdoZW5ldmVyIHlvdSBhZGQgYSBQR1Aga2V5IHRvIHRoZQ0Ka2VybmVsLCB0aGUgcGFy
c2VyIHRha2VzIG5vdCBvbmx5IHRoZSBwdWJsaWMga2V5IGFuZCB0aGUgdXNlciBJRCwNCmJ1dCBh
bHNvIGl0cyBzaWduYXR1cmUgYnkgdGhlIHNhbWUgb3IgYW5vdGhlciBQR1Aga2V5Lg0KDQpUaGUg
c2lnbmF0dXJlIGlzIHZlcmlmaWVkIHdoZW4gdGhlIGtleSBpcyBhZGRlZCB0byB0aGUga2V5cmlu
Zw0Kd2l0aCB0aGF0IHJlc3RyaWN0aW9uLCBhbmQgb25seSBpZiB0aGUgdmVyaWZpY2F0aW9uIGlz
IHN1Y2Nlc3NmdWwNCnRoZSBrZXkgY2FuIGJlIGFkZGVkLg0KDQpSb2JlcnRvDQoNCkhVQVdFSSBU
RUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3Rv
cjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQ0KDQo+IFRoYW5rcywNCj4gTWFjaWVqDQo=
