Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54517883D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 03:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbgCDCZv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 Mar 2020 21:25:51 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:26327 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387397AbgCDCZv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 Mar 2020 21:25:51 -0500
X-UUID: c295019e3c2c43a5a5bd5b6731a0597a-20200304
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WRwJNL3/LSu9YAz4lzMmh4KqQ+Mz5WRqM0Z4EacS3BA=;
        b=OpZDbhpry9lCxT8XBLFuk96dgH/gU7hMsiAKr6zInqpN7CzkwjGPHy3zWDyBWi64oEYyqAbJi7EE3/gTOpHiJuaelpeL2K05QNWxg3NK0tq64zyLBiJvKXWM1KTektECPOkVJRf+qysm9+bv+GggZwdj08lfoo2gyA1iFALswp4=;
X-UUID: c295019e3c2c43a5a5bd5b6731a0597a-20200304
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1046319018; Wed, 04 Mar 2020 10:25:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 4 Mar 2020 10:23:40 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 4 Mar 2020 10:23:04 +0800
Message-ID: <1583288736.14250.2.camel@mtksdccf07>
Subject: Re: [RFC PATCH v1] scsi: ufs-mediatek: add inline encryption support
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>, <cang@codeaurora.org>,
        <satyat@google.com>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <light.hsieh@mediatek.com>
Date:   Wed, 4 Mar 2020 10:25:36 +0800
In-Reply-To: <20200302180231.GB98133@gmail.com>
References: <20200302091138.10341-1-stanley.chu@mediatek.com>
         <20200302180231.GB98133@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SGkgRXJpYywNCg0KT24gTW9uLCAyMDIwLTAzLTAyIGF0IDEwOjAyIC0wODAwLCBFcmljIEJpZ2dl
cnMgd3JvdGU6DQo+IE9uIE1vbiwgTWFyIDAyLCAyMDIwIGF0IDA1OjExOjM4UE0gKzA4MDAsIFN0
YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEFkZCBpbmxpbmUgZW5jcnlwdGlvbiBzdXBwb3J0IHRvIHVm
cy1tZWRpYXRlay4NCj4gPiANCj4gPiBUaGUgc3RhbmRhcmRzLWNvbXBsaWFudCBwYXJ0cywgc3Vj
aCBhcyBxdWVyeWluZyB0aGUgY3J5cHRvIGNhcGFiaWxpdGllcw0KPiA+IGFuZCBlbmFibGluZyBj
cnlwdG8gZm9yIGluZGl2aWR1YWwgVUZTIHJlcXVlc3RzLCBhcmUgYWxyZWFkeSBoYW5kbGVkIGJ5
DQo+ID4gdWZzaGNkLWNyeXB0by5jLCB3aGljaCBpdHNlbGYgaXMgd2lyZWQgaW50byB0aGUgYmxr
LWNyeXB0byBmcmFtZXdvcmsuDQo+ID4gDQo+ID4gSG93ZXZlciBNZWRpYVRlayBVRlMgaG9zdCBy
ZXF1aXJlcyBhIHZlbmRvci1zcGVjaWZpYyBoY2VfZW5hYmxlIG9wZXJhdGlvbg0KPiA+IHRvIGFs
bG93IGNyeXB0by1yZWxhdGVkIHJlZ2lzdGVycyBiZWluZyBhY2Nlc3NlZCBub3JtYWxseSBpbiBr
ZXJuZWwuDQo+ID4gQWZ0ZXIgdGhpcyBzdGVwLCBNZWRpYVRlayBVRlMgaG9zdCBjYW4gd29yayBh
cyBzdGFuZGFyZC1jb21wbGlhbnQgaG9zdA0KPiA+IGZvciBpbmxpbmUtZW5jcnlwdGlvbiByZWxh
dGVkIGZ1bmN0aW9ucy4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIGlzIHJlYmFzZWQgdG8gdGhlIGxh
dGVzdCB3aXAtaW5saW5lLWVuY3J5cHRpb24gYnJhbmNoIGluDQo+ID4gRXJpYyBCaWdnZXJzJ3Mg
Z2l0Og0KPiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L2ViaWdnZXJzL2xpbnV4LmdpdC8NCj4gDQo+IFBsZWFzZSBkb24ndCB1c2UgYSByYW5kb20gd29y
ay1pbi1wcm9ncmVzcyBicmFuY2ggZnJvbSBteSBnaXQgcmVwb3NpdG9yeSAod2hpY2gNCj4gaGFz
bid0IGJlZW4gdXBkYXRlZCB0byB0aGUgdjcgcGF0Y2hzZXQgeWV0IGFuZCB3aWxsIGJlIHJlYmFz
ZWQpOyB1c2UgaW5zdGVhZDoNCj4gDQo+IAlSZXBvOiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vZnMvZnNjcnlwdC9mc2NyeXB0LmdpdA0KPiAJVGFnOiBpbmxpbmUtZW5jcnlwdGlvbi12
Nw0KPiANCj4gQWxzbywgdGhpcyBwYXRjaCBkb2Vzbid0IGFwcGx5IHRvIGVpdGhlciBicmFuY2gg
YW55d2F5Og0KPiANCj4gQXBwbHlpbmc6IHNjc2k6IHVmcy1tZWRpYXRlazogYWRkIGlubGluZSBl
bmNyeXB0aW9uIHN1cHBvcnQNCj4gVXNpbmcgaW5kZXggaW5mbyB0byByZWNvbnN0cnVjdCBhIGJh
c2UgdHJlZS4uLg0KPiBlcnJvcjogcGF0Y2ggZmFpbGVkOiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5jOjE1DQo+IGVycm9yOiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jOiBw
YXRjaCBkb2VzIG5vdCBhcHBseQ0KPiBlcnJvcjogcGF0Y2ggZmFpbGVkOiBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5oOjU4DQo+IGVycm9yOiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5oOiBwYXRjaCBkb2VzIG5vdCBhcHBseQ0KPiBlcnJvcjogRGlkIHlvdSBoYW5kIGVkaXQg
eW91ciBwYXRjaD8NCg0KU29ycnkgZm9yIHRoaXMuDQpJIHJlYmFzZWQgdGhpcyBwYXRjaCBhcyBS
RkMgdjIgdG8gYmVsb3cgdGFnLA0KDQoJUmVwbzogaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2ZzL2ZzY3J5cHQvZnNjcnlwdC5naXQNCiAJVGFnOiBpbmxpbmUtZW5jcnlwdGlvbi12Nw0K
DQoNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPiBpbmRleCA1M2VhZTVmZTJhZGUuLjEy
ZDAxZmQzZDVlMSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+IEBAIC0x
NSw2ICsxNSw3IEBADQo+ID4gICNpbmNsdWRlIDxsaW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9z
dmMuaD4NCj4gPiAgDQo+ID4gICNpbmNsdWRlICJ1ZnNoY2QuaCINCj4gPiArI2luY2x1ZGUgInVm
c2hjZC1jcnlwdG8uaCINCj4gPiAgI2luY2x1ZGUgInVmc2hjZC1wbHRmcm0uaCINCj4gPiAgI2lu
Y2x1ZGUgInVmc19xdWlya3MuaCINCj4gPiAgI2luY2x1ZGUgInVuaXByby5oIg0KPiA+IEBAIC0y
NCw2ICsyNSw5IEBADQo+ID4gIAlhcm1fc21jY2Nfc21jKE1US19TSVBfVUZTX0NPTlRST0wsIFwN
Cj4gPiAgCQkgICAgICBjbWQsIHZhbCwgMCwgMCwgMCwgMCwgMCwgJihyZXMpKQ0KPiA+ICANCj4g
PiArI2RlZmluZSB1ZnNfbXRrX2NyeXB0b19jdHJsKHJlcywgZW5hYmxlKSBcDQo+ID4gKwl1ZnNf
bXRrX3NtYyhVRlNfTVRLX1NJUF9DUllQVE9fQ1RSTCwgZW5hYmxlLCByZXMpDQo+ID4gKw0KPiA+
ICAjZGVmaW5lIHVmc19tdGtfcmVmX2Nsa19ub3RpZnkob24sIHJlcykgXA0KPiA+ICAJdWZzX210
a19zbWMoVUZTX01US19TSVBfUkVGX0NMS19OT1RJRklDQVRJT04sIG9uLCByZXMpDQo+ID4gIA0K
PiA+IEBAIC02Niw3ICs3MCwyNyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2NmZ191bmlwcm9fY2co
c3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQo+ID4gIAl9DQo+ID4gIH0NCj4gPiAg
DQo+ID4gLXN0YXRpYyBpbnQgdWZzX210a19iaW5kX21waHkoc3RydWN0IHVmc19oYmEgKmhiYSkN
Cj4gPiArc3RhdGljIHZvaWQgdWZzX210a19jcnlwdG9fZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsNCj4gPiArDQo+ID4g
Kwl1ZnNfbXRrX2NyeXB0b19jdHJsKHJlcywgMSk7DQo+ID4gKwlpZiAocmVzLmEwKSB7DQo+ID4g
KwkJZGV2X2luZm8oaGJhLT5kZXYsICIlczogY3J5cHRvIGVuYWJsZSBmYWlsZWQsIGVycjogJWx1
XG4iLA0KPiA+ICsJCQkgX19mdW5jX18sIHJlcy5hMCk7DQo+ID4gKwl9DQo+ID4gK30NCj4gPiAr
DQo+ID4gK3N0YXRpYyBpbnQgdWZzX210a19oY2VfZW5hYmxlX25vdGlmeShzdHJ1Y3QgdWZzX2hi
YSAqaGJhLA0KPiA+ICsJCQkJICAgICBlbnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyBzdGF0
dXMpDQo+ID4gK3sNCj4gPiArCWlmIChzdGF0dXMgPT0gUFJFX0NIQU5HRSAmJiB1ZnNoY2RfaGJh
X2lzX2NyeXB0b19zdXBwb3J0ZWQoaGJhKSkNCj4gPiArCQl1ZnNfbXRrX2NyeXB0b19lbmFibGUo
aGJhKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraW50IHVm
c19tdGtfYmluZF9tcGh5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4gIHsNCj4gPiAgCXN0cnVj
dCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCj4gPiAgCXN0
cnVjdCBkZXZpY2UgKmRldiA9IGhiYS0+ZGV2Ow0KPiA+IEBAIC00OTQsNiArNTE4LDcgQEAgc3Rh
dGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19oYmFfbXRrX3ZvcHMgPSB7DQo+ID4g
IAkubmFtZSAgICAgICAgICAgICAgICA9ICJtZWRpYXRlay51ZnNoY2kiLA0KPiA+ICAJLmluaXQg
ICAgICAgICAgICAgICAgPSB1ZnNfbXRrX2luaXQsDQo+ID4gIAkuc2V0dXBfY2xvY2tzICAgICAg
ICA9IHVmc19tdGtfc2V0dXBfY2xvY2tzLA0KPiA+ICsJLmhjZV9lbmFibGVfbm90aWZ5ICAgPSB1
ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5LA0KPiA+ICAJLmxpbmtfc3RhcnR1cF9ub3RpZnkgPSB1
ZnNfbXRrX2xpbmtfc3RhcnR1cF9ub3RpZnksDQo+ID4gIAkucHdyX2NoYW5nZV9ub3RpZnkgICA9
IHVmc19tdGtfcHdyX2NoYW5nZV9ub3RpZnksDQo+ID4gIAkuYXBwbHlfZGV2X3F1aXJrcyAgICA9
IHVmc19tdGtfYXBwbHlfZGV2X3F1aXJrcywNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCj4g
PiBpbmRleCBmY2NkZDk3OWQ2ZmIuLjVlYmFhNTk4OThiZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnMtbWVkaWF0ZWsuaA0KPiA+IEBAIC01OCw2ICs1OCw3IEBADQo+ID4gICAqLw0KPiA+ICAjZGVm
aW5lIE1US19TSVBfVUZTX0NPTlRST0wgICAgICAgICAgICAgICBNVEtfU0lQX1NNQ19DTUQoMHgy
NzYpDQo+ID4gICNkZWZpbmUgVUZTX01US19TSVBfREVWSUNFX1JFU0VUICAgICAgICAgIEJJVCgx
KQ0KPiA+ICsjZGVmaW5lIFVGU19NVEtfU0lQX0NSWVBUT19DVFJMICAgICAgICAgICBCSVQoMikN
Cj4gPiAgI2RlZmluZSBVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiAgQklUKDMpDQo+
IA0KPiBCdXQgaWYgdGhpcyBpcyBhbGwgdGhhdCdzIG5lZWRlZCB0byBnZXQgaW5saW5lIGNyeXB0
byB3b3JraW5nIHdpdGggTWVkaWF0ZWsgVUZTLA0KPiB0aGF0J3MgZ3JlYXQgbmV3cy4NCg0KVGhh
bmtzIGZvciB5b3VyIHJldmlldyA6KQ0KDQpTdGFubGV5IENodQ0KDQoNCg0KPiANCj4gVGhhbmtz
IQ0KPiANCj4gLSBFcmljDQoNCg==

