Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC5F2C3B88
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Nov 2020 10:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgKYJDS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Nov 2020 04:03:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:33950 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbgKYJDR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Nov 2020 04:03:17 -0500
X-UUID: 1be26dd3e9be47b0b163be482a6e27a0-20201125
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=skSnb2uDvb1vlU54SCp6k//nUUsyIWhbFS4nwVqKjDw=;
        b=CCkLZ9yicm3WklI7eFj5qtI4wjrnyFLh0jwdhk+5x7JGqqp4/DLzD3DX6uq9SjBTDjIFOofOSYvXBysg8AppreWdSePQ3cKmxv5AefiK8o1HcpPK4ZQNvexPXqVuhV80z5C5PcfsyYPWjkrSOJPnwa2KNB/jPexFBaHVdCfTt2A=;
X-UUID: 1be26dd3e9be47b0b163be482a6e27a0-20201125
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 163410696; Wed, 25 Nov 2020 17:03:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 25 Nov 2020 17:03:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Nov 2020 17:03:10 +0800
Message-ID: <1606294991.31568.5.camel@mtkswgap22>
Subject: Re: [PATCH 0/8] eMMC inline encryption support
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        "Barani Muthukumaran" <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>,
        <kuohong.wang@mediatek.com>, <gray.jia@mediatek.com>,
        <stanley.chu@mediatek.com>
Date:   Wed, 25 Nov 2020 17:03:11 +0800
In-Reply-To: <X7xpbJf4gDcFdEc/@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
         <X7gQ9Y44iIgkiM64@sol.localdomain>
         <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
         <X7gcsC6IS80sUy4K@sol.localdomain>
         <9010afea-1075-8f72-99c7-c471840685db@intel.com>
         <X7xpbJf4gDcFdEc/@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SGkgRXJpYywNCg0KT24gTW9uLCAyMDIwLTExLTIzIGF0IDE4OjAxIC0wODAwLCBFcmljIEJpZ2dl
cnMgd3JvdGU6DQo+IEhpIEFkcmlhbiwNCj4gDQo+IE9uIE1vbiwgTm92IDIzLCAyMDIwIGF0IDA5
OjA0OjEyQU0gKzAyMDAsIEFkcmlhbiBIdW50ZXIgd3JvdGU6DQo+ID4gT24gMjAvMTEvMjAgOTo0
NCBwbSwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KPiA+ID4gSGkgQWRyaWFuLA0KPiA+ID4gDQo+ID4g
PiBPbiBGcmksIE5vdiAyMCwgMjAyMCBhdCAwOToyOTo1OVBNICswMjAwLCBBZHJpYW4gSHVudGVy
IHdyb3RlOg0KPiA+ID4+IEkgaGF2ZW4ndCBoYWQgYSBjaGFuY2UgdG8gbG9vayBhdCBpdCBwcm9w
ZXJseSwgYnV0IEkgZG8gaGF2ZSBhIGNvdXBsZSBvZg0KPiA+ID4+IGR1bWIgcXVlc3Rpb25zLiAg
SG93IGRvIHlvdSBlbnN1cmUgdGhlIGhvc3QgY29udHJvbGxlciBpcyBub3QgcnVudGltZQ0KPiA+
ID4+IHN1c3BlbmRlZCB3aGVuIHRoZSBrZXkgaXMgcHJvZ3JhbW1lZD8NCj4gPiA+IA0KPiA+ID4g
VGhpcyBpcyBoYW5kbGVkIGJ5IHRoZSBibG9jayBsYXllciwgaW4gYmxvY2sva2V5c2xvdC1tYW5h
Z2VyLmMuICBJdCBlbnN1cmVzIHRoYXQNCj4gPiA+IHRoZSBkZXZpY2UgaXMgcmVzdW1lZCBiZWZv
cmUgY2FsbGluZyBibGtfa3NtX2xsX29wczo6a2V5c2xvdF9wcm9ncmFtKCkgb3INCj4gPiA+IGJs
a19rc21fbGxfb3BzOjprZXlzbG90X2V2aWN0KCkuICBTZWUgYmxrX2tzbV9od19lbnRlcigpLg0K
PiA+IA0KPiA+IENvb2wsIGFsdGhvdWdoIGNxaGNpIGlzIGRvaW5nIGEgbGF6eSBraW5kIG9mIHJl
c3VtZSwgc28gbWF5YmUgbm90IGJlIGVuYWJsZWQNCj4gPiB3aGVuIGEga2V5IGlzIHByb2dyYW1t
ZWQ/ICBXb3VsZCB0aGF0IGJlIGEgcHJvYmxlbT8NCj4gPiANCj4gPiA+IA0KPiA+ID4+IEFyZSB0
aGUga2V5cyBsb3N0IHdoZW4gdGhlIGhvc3QgY29udHJvbGxlciBpcyByZXNldCwgYW5kIHRoZW4g
aG93IGRvIHlvdSBrbm93DQo+ID4gPj4gdGhlIGhvc3QgY29udHJvbGxlciBkb2VzIG5vdCBnZXQg
cmVzZXQgYWZ0ZXIgdGhlIGtleSBpcyBwcm9ncmFtbWVkIGJ1dCBiZWZvcmUNCj4gPiA+PiB0aGUg
SS9PIGlzIHN1Ym1pdHRlZD8NCj4gPiA+IA0KPiA+ID4gQXMgd2l0aCBVRlMsIGtleXMgbWlnaHQg
YmUgbG9zdCB3aGVuIHRoZSBob3N0IGNvbnRyb2xsZXIgaXMgcmVzZXQsIHNvIHdlJ3JlDQo+ID4g
PiByZXByb2dyYW1taW5nIGFsbCB0aGUga2V5cyB3aGVuIHRoYXQgaGFwcGVucy4gIFNlZSBwYXRj
aCAxOg0KPiA+ID4gDQo+ID4gPiAgICAgbW1jX3NldF9pbml0aWFsX3N0YXRlKCkNCj4gPiA+ICAg
ICAgICAgbW1jX2NyeXB0b19zZXRfaW5pdGlhbF9zdGF0ZSgpDQo+ID4gPiAgICAgICAgICAgICBi
bGtfa3NtX3JlcHJvZ3JhbV9hbGxfa2V5cygpDQo+ID4gPiANCj4gPiA+IChUaGF0J3MgdGhlIGlu
dGVudCwgYXQgbGVhc3QuICBGb3IgTU1DLCBJJ20gbm90IHN1cmUgaWYgcmVzZXRzIHdlcmUgcHJv
cGVybHkNCj4gPiA+IGNvdmVyZWQgYnkgdGhlIHRlc3RpbmcgSSd2ZSBkb25lIHNvIGZhci4gIEJ1
dCB0aGUgY29kZSBsb29rcyByaWdodCB0byBtZS4pDQo+ID4gDQo+ID4gQWZ0ZXIgcmVzZXQsIGNx
aGNpIHdpbGwgbm90IG5lY2Vzc2FyaWx5IGJlIGVuYWJsZWQgYXQgdGhpcyBwb2ludC4gIElzIHRo
YXQgT0s/DQo+IA0KPiBUaGUgaGFyZHdhcmUgdGhhdCBJIGhhdmUgKHNkbTYzMCkgYXBwZWFycyB0
byBhbGxvdyBwcm9ncmFtbWluZyBhbmQgZXZpY3Rpbmcga2V5cw0KPiBldmVuIHdoaWxlIENRSENJ
X0NGRy5DUUhDSV9FTkFCTEUgaXMgY2xlYXIsIGkuZS4gZXZlbiB3aGVuIHRoZSBDUUUgaXMgIm9m
ZiIuDQo+IEkgdGVzdGVkIGl0IHVzaW5nIHRoZSBwYXRjaCBiZWxvdy4NCj4gDQo+IFRoZSBlTU1D
IHNwZWNpZmljYXRpb24gaXNuJ3QgY2xlYXIgYWJvdXQgdGhpcyBwb2ludC4gIEJ1dCBJJ20gdGhp
bmtpbmcgdGhhdCB0aGUNCj4gY3J5cHRvIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXJzICh0aGUga2V5
c2xvdHMpIGFyZSBwcm9iYWJseSBzdXBwb3NlZCB0byB3b3JrIGxpa2UNCj4gbW9zdCBvZiB0aGUg
b3RoZXIgQ1FIQ0kgcmVnaXN0ZXJzLCB3aGljaCBjYW4gYmUgd3JpdHRlbiB0byB3aGlsZSBDUUhD
SV9FTkFCTEUgaXMNCj4gY2xlYXIuICBUaGVuIHNldHRpbmcgQ1FIQ0lfRU5BQkxFIGp1c3QgZW5h
YmxlcyB0aGUgYWJpbGl0eSB0byBhY3R1YWxseSBpc3N1ZQ0KPiByZXF1ZXN0cy4gIExpa2V3aXNl
LCBzZXR0aW5nIENRSENJX0NSWVBUT19HRU5FUkFMX0VOQUJMRSBqdXN0IGFsbG93cyB1c2luZw0K
PiBjcnlwdG8gaW4gcmVxdWVzdHM7IGl0IGlzbid0IG5lZWRlZCB0byB3cml0ZSB0byB0aGUgY3J5
cHRvIGNvbmZpZ3VyYXRpb25zLg0KPiANCj4gRm9yIHdoYXQgaXQncyB3b3J0aCwgVUZTIGNyeXB0
byAod2hpY2ggaGFzIGJlZW4gc3VwcG9ydGVkIGJ5IHVwc3RyZWFtIHNpbmNlDQo+IHY1LjkpIHdv
cmtzIHNpbWlsYXJseS4gIEtleXMgY2FuIGJlIHByb2dyYW1tZWQgd2hpbGUgdGhlIFVGUyBob3N0
IGlzIHBvd2VyZWQgb24sDQo+IGV2ZW4gYmVmb3JlIGl0J3MgImVuYWJsZWQiLg0KPiANCj4gQnV0
IG1heWJlIHNvbWVvbmUgaW50ZXJwcmV0ZWQgdGhlIGVNTUMgc3BlY2lmaWNhdGlvbiBkaWZmZXJl
bnRseS4gIEhvcGVmdWxseQ0KPiBNZWRpYXRlayBjYW4gZ2l2ZSBzb21lIGluc2lnaHQgaW50byBo
b3cgdGhleSBpbXBsZW1lbnRlZCBpdCwgYW5kIHRlc3QgdGhpcw0KPiBwYXRjaHNldCBvbiB0aGVp
ciBoYXJkd2FyZSB0b28uDQoNCk1lZGlhVGVrIENRSENJIGFsc28gd29ya3MgaW4gdGhpcyB3YXku
DQoNCkNvbXBsZXRlIHRlc3QgaXMgb24tZ29pbmcgbm93IGFuZCB3ZSB3aWxsIHVwZGF0ZSB0aGUg
cmVzdWx0cyBhcyBzb29uIGFzDQpwb3NzaWJsZS4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K
PiANCj4gSGVyZSdzIHRoZSBwYXRjaCBJIHVzZWQgdG8gdmVyaWZ5IHRoYXQgc2RtNjMwIGFsbG93
cyBwcm9ncmFtbWluZyBhbmQgZXZpY3RpbmcNCj4ga2V5cyBldmVuIHdoaWxlIHRoZSBDUUUgaXMg
b2ZmOg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NvcmUvYmxvY2suYyBiL2RyaXZl
cnMvbW1jL2NvcmUvYmxvY2suYw0KPiBpbmRleCBlYWYyZjEwNzQzMjYuLmViMmQ4OGQwYjNiYSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tbWMvY29yZS9ibG9jay5jDQo+ICsrKyBiL2RyaXZlcnMv
bW1jL2NvcmUvYmxvY2suYw0KPiBAQCAtMTQwNiw2ICsxNDA2LDkgQEAgc3RhdGljIHZvaWQgbW1j
X2Jsa19jcWVfY29tcGxldGVfcnEoc3RydWN0IG1tY19xdWV1ZSAqbXEsIHN0cnVjdCByZXF1ZXN0
ICpyZXEpDQo+ICANCj4gIAltbWNfY3FlX2NoZWNrX2J1c3kobXEpOw0KPiAgDQo+ICsJaWYgKG1t
Y190b3RfaW5fZmxpZ2h0KG1xKSA9PSAwICYmIGhvc3QtPmNxZV9vbikNCj4gKwkJaG9zdC0+Y3Fl
X29wcy0+Y3FlX29mZihob3N0KTsNCj4gKw0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1x
LT5sb2NrLCBmbGFncyk7DQo+ICANCj4gIAlpZiAoIW1xLT5jcWVfYnVzeSkNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbW1jL2hvc3Qvc2RoY2ktbXNtLmMgYi9kcml2ZXJzL21tYy9ob3N0L3NkaGNp
LW1zbS5jDQo+IGluZGV4IDZjZTIxNDE0ZDUxMC4uNzBkOGRiYzY1MTVmIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL21tYy9ob3N0L3NkaGNpLW1zbS5jDQo+ICsrKyBiL2RyaXZlcnMvbW1jL2hvc3Qv
c2RoY2ktbXNtLmMNCj4gQEAgLTE5NzEsNiArMTk3MSwxMiBAQCBzdGF0aWMgaW50IHNkaGNpX21z
bV9wcm9ncmFtX2tleShzdHJ1Y3QgY3FoY2lfaG9zdCAqY3FfaG9zdCwNCj4gIAlpbnQgaTsNCj4g
IAlpbnQgZXJyOw0KPiAgDQo+ICsJaWYgKCFjcV9ob3N0LT5tbWMtPmNxZV9vbikgew0KPiArCQlw
cl9pbmZvKCJAQEAgY3FlIGlzIG9mZiBmb3IgJXMgc2xvdCAlZFxuIiwNCj4gKwkJCShjZmctPmNv
bmZpZ19lbmFibGUgJiBDUUhDSV9DUllQVE9fQ09ORklHVVJBVElPTl9FTkFCTEUpID8NCj4gKwkJ
CSJwcm9ncmFtIiA6ICJldmljdCIsIHNsb3QpOw0KPiArCX0NCj4gKw0KPiAgCWlmICghKGNmZy0+
Y29uZmlnX2VuYWJsZSAmIENRSENJX0NSWVBUT19DT05GSUdVUkFUSU9OX0VOQUJMRSkpDQo+ICAJ
CXJldHVybiBxY29tX3NjbV9pY2VfaW52YWxpZGF0ZV9rZXkoc2xvdCk7DQoNCg==

