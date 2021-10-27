Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F0543C562
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Oct 2021 10:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbhJ0IoY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Oct 2021 04:44:24 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4031 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239407AbhJ0IoY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Oct 2021 04:44:24 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HfMWP5vgbz6H7dv;
        Wed, 27 Oct 2021 16:37:21 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 10:41:56 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.015;
 Wed, 27 Oct 2021 10:41:56 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Deven Bowers <deven.desai@linux.microsoft.com>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
Subject: RE: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Thread-Topic: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Thread-Index: AQHXwGWUN6BqcPCg3Uma5jdt5usPz6vRLYAAgAMlHYCAAAy0gIAHoD6wgAM9LeCABllegIABBN/w
Date:   Wed, 27 Oct 2021 08:41:56 +0000
Message-ID: <7ba78ee8bf444fe99e1e7346dad475b7@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
 <YWngaVdvMyWBlITZ@gmail.com> <5c1f800ba554485cb3659da689d2079a@huawei.com>
 <a16a628b9e21433198c490500a987121@huawei.com>
 <40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
In-Reply-To: <40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

PiBGcm9tOiBEZXZlbiBCb3dlcnMgW21haWx0bzpkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQu
Y29tXQ0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDI2LCAyMDIxIDk6MDQgUE0NCj4gT24gMTAv
MjIvMjAyMSA5OjMxIEFNLCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+PiBGcm9tOiBSb2JlcnRv
IFNhc3N1IFttYWlsdG86cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tXQ0KPiA+PiBTZW50OiBXZWRu
ZXNkYXksIE9jdG9iZXIgMjAsIDIwMjEgNTowOSBQTQ0KPiA+Pj4gRnJvbTogRXJpYyBCaWdnZXJz
IFttYWlsdG86ZWJpZ2dlcnNAa2VybmVsLm9yZ10NCj4gPj4+IFNlbnQ6IEZyaWRheSwgT2N0b2Jl
ciAxNSwgMjAyMSAxMDoxMSBQTQ0KPiA+Pj4gT24gRnJpLCBPY3QgMTUsIDIwMjEgYXQgMTI6MjU6
NTNQTSAtMDcwMCwgRGV2ZW4gQm93ZXJzIHdyb3RlOg0KPiA+Pj4+IE9uIDEwLzEzLzIwMjEgMTI6
MjQgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gPj4+Pj4gT24gV2VkLCBPY3QgMTMsIDIwMjEg
YXQgMTI6MDY6MzFQTSAtMDcwMCwNCj4gPj4+IGRldmVuLmRlc2FpQGxpbnV4Lm1pY3Jvc29mdC5j
b20gIHdyb3RlOg0KPiA+Pj4+Pj4gRnJvbTogRmFuIFd1PHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5j
b20+DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gQWRkIHNlY3VyaXR5X2lub2RlX3NldHNlY3VyaXR5IHRv
IGZzdmVyaXR5IHNpZ25hdHVyZSB2ZXJpZmljYXRpb24uDQo+ID4+Pj4+PiBUaGlzIGNhbiBsZXQg
TFNNcyBzYXZlIHRoZSBzaWduYXR1cmUgZGF0YSBhbmQgZGlnZXN0IGhhc2hlcyBwcm92aWRlZA0K
PiA+Pj4+Pj4gYnkgZnN2ZXJpdHkuDQo+ID4+Pj4+IENhbiB5b3UgZWxhYm9yYXRlIG9uIHdoeSBM
U01zIG5lZWQgdGhpcyBpbmZvcm1hdGlvbj8NCj4gPj4+PiBUaGUgcHJvcG9zZWQgTFNNIChJUEUp
IG9mIHRoaXMgc2VyaWVzIHdpbGwgYmUgdGhlIG9ubHkgb25lIHRvIG5lZWQNCj4gPj4+PiB0aGlz
IGluZm9ybWF0aW9uIGF0IHRoZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhhdmUgcHJv
dmlkZQ0KPiA+Pj4+IHRydXN0LWJhc2VkIGFjY2VzcyBjb250cm9sLiBUcnVzdCBhbmQgSW50ZWdy
aXR5IGFyZSB0aWVkIHRvZ2V0aGVyLA0KPiA+Pj4+IGFzIHlvdSBjYW5ub3QgcHJvdmUgdHJ1c3Qg
d2l0aG91dCBwcm92aW5nIGludGVncml0eS4NCj4gPj4+IEkgdGhpbmsgeW91IG1lYW4gYXV0aGVu
dGljaXR5LCBub3QgaW50ZWdyaXR5Pw0KPiA+Pj4NCj4gPj4+IEFsc28gaG93IGRvZXMgdGhpcyBk
aWZmZXIgZnJvbSBJTUE/ICBJIGtub3cgdGhhdCBJTUEgZG9lc24ndCBzdXBwb3J0IGZzLQ0KPiB2
ZXJpdHkNCj4gPj4+IGZpbGUgaGFzaGVzLCBidXQgdGhhdCBjb3VsZCBiZSBjaGFuZ2VkLiAgV2h5
IG5vdCBleHRlbmQgSU1BIHRvIGNvdmVyIHlvdXINCj4gdXNlDQo+ID4+PiBjYXNlKHMpPw0KPiA+
Pj4NCj4gPj4+PiBJUEUgbmVlZHMgdGhlIGRpZ2VzdCBpbmZvcm1hdGlvbiB0byBiZSBhYmxlIHRv
IGNvbXBhcmUgYSBkaWdlc3QNCj4gPj4+PiBwcm92aWRlZCBieSB0aGUgcG9saWN5IGF1dGhvciwg
YWdhaW5zdCB0aGUgZGlnZXN0IGNhbGN1bGF0ZWQgYnkNCj4gPj4+PiBmc3Zlcml0eSB0byBtYWtl
IGEgZGVjaXNpb24gb24gd2hldGhlciB0aGF0IHNwZWNpZmljIGZpbGUsIHJlcHJlc2VudGVkDQo+
ID4+Pj4gYnkgdGhlIGRpZ2VzdCBpcyBhdXRob3JpemVkIGZvciB0aGUgYWN0aW9ucyBzcGVjaWZp
ZWQgaW4gdGhlIHBvbGljeS4NCj4gPj4+Pg0KPiA+Pj4+IEEgbW9yZSBjb25jcmV0ZSBleGFtcGxl
LCBpZiBhbiBJUEUgcG9saWN5IGF1dGhvciB3cml0ZXM6DQo+ID4+Pj4NCj4gPj4+PiAgwqDCoMKg
IG9wPUVYRUNVVEUgZnN2ZXJpdHlfZGlnZXN0PTxIZXhEaWdlc3QgPiBhY3Rpb249REVOWQ0KPiA+
Pj4+DQo+ID4+Pj4gSVBFIHRha2VzIHRoZSBkaWdlc3QgcHJvdmlkZWQgYnkgdGhpcyBzZWN1cml0
eSBob29rLCBzdG9yZXMgaXQNCj4gPj4+PiBpbiBJUEUncyBzZWN1cml0eSBibG9iIG9uIHRoZSBp
bm9kZS4gSWYgdGhpcyBmaWxlIGlzIGxhdGVyDQo+ID4+Pj4gZXhlY3V0ZWQsIElQRSBjb21wYXJl
cyB0aGUgZGlnZXN0IHN0b3JlZCBpbiB0aGUgTFNNIGJsb2IsDQo+ID4+Pj4gcHJvdmlkZWQgYnkg
dGhpcyBob29rLCBhZ2FpbnN0IDxIZXhEaWdlc3Q+IGluIHRoZSBwb2xpY3ksIGlmDQo+ID4+Pj4g
aXQgbWF0Y2hlcywgaXQgZGVuaWVzIHRoZSBhY2Nlc3MsIHBlcmZvcm1pbmcgYSByZXZvY2F0aW9u
DQo+ID4+Pj4gb2YgdGhhdCBmaWxlLg0KPiA+Pj4gRG8geW91IGhhdmUgYSBiZXR0ZXIgZXhhbXBs
ZT8gIFRoaXMgb25lIGlzIHByZXR0eSB1c2VsZXNzIHNpbmNlIG9uZSBjYW4gZ2V0DQo+ID4+PiBh
cm91bmQgaXQganVzdCBieSBleGVjdXRpbmcgYSBmaWxlIHRoYXQgZG9lc24ndCBoYXZlIGZzLXZl
cml0eSBlbmFibGVkLg0KPiA+PiBJIHdhcyB3b25kZXJpbmcgaWYgdGhlIGZvbGxvd2luZyB1c2Ug
Y2FzZSBjYW4gYmUgc3VwcG9ydGVkOg0KPiA+PiBhbGxvdyB0aGUgZXhlY3V0aW9uIG9mIGZpbGVz
IHByb3RlY3RlZCB3aXRoIGZzdmVyaXR5IGlmIHRoZSByb290DQo+ID4+IGRpZ2VzdCBpcyBmb3Vu
ZCBhbW9uZyByZWZlcmVuY2UgdmFsdWVzIChpbnN0ZWFkIG9mIHByb3ZpZGluZw0KPiA+PiB0aGVt
IG9uZSBieSBvbmUgaW4gdGhlIHBvbGljeSkuDQo+ID4+DQo+ID4+IFNvbWV0aGluZyBsaWtlOg0K
PiA+Pg0KPiA+PiBvcD1FWEVDVVRFIGZzdmVyaXR5X2RpZ2VzdD1kaWdsaW0gYWN0aW9uPUFMTE9X
DQo+ID4gTG9va3MgbGlrZSBpdCB3b3Jrcy4gSSBtb2RpZmllZCBJUEUgdG8gcXVlcnkgdGhlIHJv
b3QgZGlnZXN0DQo+ID4gb2YgYW4gZnN2ZXJpdHktcHJvdGVjdGVkIGZpbGUgaW4gRElHTElNLg0K
PiA+DQo+ID4gIyBjYXQgaXBlLXBvbGljeQ0KPiA+IHBvbGljeV9uYW1lPSJBbGxvd0ZTVmVyaXR5
S21vZHVsZXMiIHBvbGljeV92ZXJzaW9uPTAuMC4xDQo+ID4gREVGQVVMVCBhY3Rpb249QUxMT1cN
Cj4gPiBERUZBVUxUIG9wPUtNT0RVTEUgYWN0aW9uPURFTlkNCj4gPiBvcD1LTU9EVUxFIGZzdmVy
aXR5X2RpZ2VzdD1kaWdsaW0gYWN0aW9uPUFMTE9XDQo+ID4NCj4gPiBJUEUgc2V0dXA6DQo+ID4g
IyBjYXQgaXBlLXBvbGljeS5wN3MgPiAvc3lzL2tlcm5lbC9zZWN1cml0eS9pcGUvbmV3X3BvbGlj
eQ0KPiA+ICMgZWNobyAtbiAxID4gIC9zeXMva2VybmVsL3NlY3VyaXR5L2lwZS9wb2xpY2llcy9B
bGxvd0ZTVmVyaXR5S21vZHVsZXMvYWN0aXZlDQo+ID4gIyBlY2hvIDEgPiAvc3lzL2tlcm5lbC9z
ZWN1cml0eS9pcGUvZW5mb3JjZQ0KPiA+DQo+ID4gSVBFIGRlbmllcyBsb2FkaW5nIG9mIGtlcm5l
bCBtb2R1bGVzIG5vdCBwcm90ZWN0ZWQgYnkgZnN2ZXJpdHk6DQo+ID4gIyBpbnNtb2QgIC9saWIv
bW9kdWxlcy81LjE1LjAtcmMxKy9rZXJuZWwvZnMvZmF0L2ZhdC5rbw0KPiA+IGluc21vZDogRVJS
T1I6IGNvdWxkIG5vdCBpbnNlcnQgbW9kdWxlIC9saWIvbW9kdWxlcy81LjE1LjAtDQo+IHJjMSsv
a2VybmVsL2ZzL2ZhdC9mYXQua286IFBlcm1pc3Npb24gZGVuaWVkDQo+ID4NCj4gPiBQcm90ZWN0
IGZhdC5rbyB3aXRoIGZzdmVyaXR5Og0KPiA+ICMgY3AgL2xpYi9tb2R1bGVzLzUuMTUuMC1yYzEr
L2tlcm5lbC9mcy9mYXQvZmF0LmtvIC9mc3Zlcml0eQ0KPiA+ICMgZnN2ZXJpdHkgZW5hYmxlIC9m
c3Zlcml0eS9mYXQua28NCj4gPiAjIGZzdmVyaXR5IG1lYXN1cmUgL2ZzdmVyaXR5L2ZhdC5rbw0K
PiA+DQo+IHNoYTI1NjowNzliZTZkODg2MzhlNTgxNDFlZTI0YmJhODk4MTM5MTdjNDRmYWE1NWFk
YTRiZjVkODAzMzVlZmUxNTQNCj4gNzgwMyAvZnN2ZXJpdHkvZmF0LmtvDQo+ID4NCj4gPiBJUEUg
c3RpbGwgZGVuaWVzIHRoZSBsb2FkaW5nIG9mIGZhdC5rbyAocm9vdCBkaWdlc3Qgbm90IHVwbG9h
ZGVkIHRvIHRoZSBrZXJuZWwpOg0KPiA+ICMgaW5zbW9kIC9mc3Zlcml0eS9mYXQua28NCj4gPiBp
bnNtb2Q6IEVSUk9SOiBjb3VsZCBub3QgaW5zZXJ0IG1vZHVsZSAvZnN2ZXJpdHkvZmF0LmtvOiBQ
ZXJtaXNzaW9uIGRlbmllZA0KPiA+DQo+ID4gR2VuZXJhdGUgYSBkaWdlc3QgbGlzdCB3aXRoIHRo
ZSByb290IGRpZ2VzdCBhYm92ZSBhbmQgdXBsb2FkIGl0IHRvIHRoZSBrZXJuZWw6DQo+ID4gIyAu
L2NvbXBhY3RfZ2VuIC1pDQo+IDA3OWJlNmQ4ODYzOGU1ODE0MWVlMjRiYmE4OTgxMzkxN2M0NGZh
YTU1YWRhNGJmNWQ4MDMzNWVmZTE1NDc4MDMgLWENCj4gc2hhMjU2IC1kIHRlc3QgLXMgLXQgZmls
ZSAtZg0KPiA+ICMgZWNobyAkUFdEL3Rlc3QvMC1maWxlX2xpc3QtY29tcGFjdC0NCj4gMDc5YmU2
ZDg4NjM4ZTU4MTQxZWUyNGJiYTg5ODEzOTE3YzQ0ZmFhNTVhZGE0YmY1ZDgwMzM1ZWZlMTU0Nzgw
MyA+DQo+IC9zeXMva2VybmVsL3NlY3VyaXR5L2ludGVncml0eS9kaWdsaW0vZGlnZXN0X2xpc3Rf
YWRkDQo+ID4NCj4gPiBJUEUgYWxsb3dzIHRoZSBsb2FkaW5nIG9mIGZhdC5rbzoNCj4gPiAjIGlu
c21vZCAvZnN2ZXJpdHkvZmF0LmtvDQo+ID4gIw0KPiA+DQo+ID4gUmVnYXJkaW5nIGF1dGhlbnRp
Y2l0eSwgbm90IHNob3duIGluIHRoaXMgZGVtbywgSVBFIHdpbGwgYWxzbw0KPiA+IGVuc3VyZSB0
aGF0IHRoZSByb290IGRpZ2VzdCBpcyBzaWduZWQgKGRpZ2xpbV9kaWdlc3RfZ2V0X2luZm8oKQ0K
PiA+IHJlcG9ydHMgdGhpcyBpbmZvcm1hdGlvbikuDQo+IA0KPiBJIGFwb2xvZ2l6ZSBmb3IgdGhl
IGRlbGF5IGluIHJlc3BvbnNlcywgYnV0IGl0IGxvb2tzIGxpa2UNCj4geW91J3ZlIGZpZ3VyZWQg
aXQgb3V0Lg0KDQpObyBwcm9ibGVtLg0KDQo+IFRoaXMga2luZCBvZiB0aGluZyBpcyBleGFjdGx5
IHdoYXQgSVBFJ3MgZGVzaWduIGlzIHN1cHBvc2VkIHRvDQo+IHNvbHZlLCB5b3UgaGF2ZSBzb21l
IG90aGVyIHN5c3RlbSB3aGljaCBwcm92aWRlcyB0aGUNCj4gaW50ZWdyaXR5IG1lY2hhbmlzbSBh
bmQgKG9wdGlvbmFsbHkpIGRldGVybWluZSBpZiBpdCBpcyB0cnVzdGVkIG9yDQo+IG5vdCwgYW5k
IElQRSBjYW4gcHJvdmlkZSB0aGUgcG9saWN5IGFzcGVjdCB2ZXJ5IGVhc2lseSB0bw0KPiBtYWtl
IGEgc2V0IG9mIHN5c3RlbS13aWRlIHJlcXVpcmVtZW50cyBhcm91bmQgeW91ciBtZWNoYW5pc20u
DQo+IA0KPiBJJ20gdmVyeSBzdXBwb3J0aXZlIG9mIGFkZGluZyB0aGUgZnVuY3Rpb25hbGl0eSwg
YnV0IEkgd29uZGVyDQo+IGlmIGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8gaGF2ZSBkaWdpbG0ncyBl
eHRlbnNpb24gYmUgYSBzZXBhcmF0ZQ0KPiBrZXkgaW5zdGVhZCBvZiB0aWVkIHRvIHRoZSBmc3Zl
cml0eV9kaWdlc3Qga2V5IC0gc29tZXRoaW5nIGxpa2UNCj4gDQo+ICAgICBvcD1FWEVDVVRFIGRp
Z2xpbV9mc3Zlcml0eT1UUlVFIGFjdGlvbj1ERU5ZDQo+IA0KPiB0aGF0IHdheSB0aGUgY29uZGl0
aW9uIHRoYXQgZW5hYmxlcyB0aGlzIHByb3BlcnR5IGNhbiBkZXBlbmQNCj4gb24gZGlnaWxtIGlu
IHRoZSBidWlsZCwgYW5kIGl0IHNlcGFyYXRlcyB0aGUgdHdvIHN5c3RlbXMnDQo+IGludGVncmF0
aW9ucyBpbiBhIHNsaWdodGx5IG1vcmUgY2xlYW4gd2F5Lg0KDQpZZXMsIEkgYWdyZWUuIEl0IGlz
IG11Y2ggbW9yZSBjbGVhbi4NCg0KPiBBcyBhbiBhc2lkZSwgZGlkIHlvdSBmaW5kIGl0IGRpZmZp
Y3VsdCB0byBleHRlbmQ/DQoNCk5vLCBpdCB3YXMgdmVyeSBzdHJhaWdodGZvcndhcmQuDQoNClJv
YmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMN
Ck1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQoNCj4gPiBSb2JlcnRv
DQo+ID4NCj4gPiBIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2
Mw0KPiA+IE1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQo+ID4NCj4g
Pj4gRElHTElNIGlzIGEgY29tcG9uZW50IEknbSB3b3JraW5nIG9uIHRoYXQgZ2VuZXJpY2FsbHkN
Cj4gPj4gc3RvcmVzIGRpZ2VzdHMuIFRoZSBjdXJyZW50IHVzZSBjYXNlIGlzIHRvIHN0b3JlIGZp
bGUgZGlnZXN0cw0KPiA+PiBmcm9tIFJQTVRBR19GSUxFRElHRVNUUyBhbmQgdXNlIHRoZW0gd2l0
aCBJTUEsIGJ1dA0KPiA+PiB0aGUgZnN2ZXJpdHkgdXNlIGNhc2UgY291bGQgYmUgZWFzaWx5IHN1
cHBvcnRlZCAoaWYgdGhlIHJvb3QNCj4gPj4gZGlnZXN0IGlzIHN0b3JlZCBpbiB0aGUgUlBNIGhl
YWRlcikuDQo+ID4+DQo+ID4+IERJR0xJTSBhbHNvIHRlbGxzIHdoZXRoZXIgb3Igbm90IHRoZSBz
aWduYXR1cmUgb2YgdGhlIHNvdXJjZQ0KPiA+PiBjb250YWluaW5nIGZpbGUgZGlnZXN0cyAob3Ig
ZnN2ZXJpdHkgZGlnZXN0cykgaXMgdmFsaWQgKHRoZSBzaWduYXR1cmUNCj4gPj4gb2YgdGhlIFJQ
TSBoZWFkZXIgaXMgdGFrZW4gZnJvbSBSUE1UQUdfUlNBSEVBREVSKS4NCj4gPj4NCj4gPj4gVGhl
IG1lbW9yeSBvY2N1cGF0aW9uIGlzIHJlbGF0aXZlbHkgc21hbGwgZm9yIGV4ZWN1dGFibGVzDQo+
ID4+IGFuZCBzaGFyZWQgbGlicmFyaWVzLiBJIHB1Ymxpc2hlZCBhIGRlbW8gZm9yIEZlZG9yYSBh
bmQNCj4gPj4gb3BlblNVU0Ugc29tZSB0aW1lIGFnbzoNCj4gPj4NCj4gPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtDQo+ID4+IGludGVncml0eS80OGNkNzM3YzUwNGQ0NTIwODM3N2Rh
YTI3ZDYyNTUzMUBodWF3ZWkuY29tLw0KPiA+Pg0KPiA+PiBUaGFua3MNCj4gPj4NCj4gPj4gUm9i
ZXJ0bw0KPiA+Pg0KPiA+PiBIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhS
QiA1NjA2Mw0KPiA+PiBNYW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQ0K
