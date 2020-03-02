Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCBE1756A1
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Mar 2020 10:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCBJLr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Mar 2020 04:11:47 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36558 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726382AbgCBJLr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Mar 2020 04:11:47 -0500
X-UUID: 85e8bf4af8164fee9720b06c6b768bef-20200302
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0Y23yxwohWhXaBotvUv65ILHSsUsxieq1MmLFigexZw=;
        b=vAK36ER269blXWVp9ID1zgWmo9YVYJ4yZROsmsh22z0kJguPv94Cbr9fvWNRUty0Vqt7P2L3rjw3La5SWEKG/lVcW2EhwGaYYQh6HZDR4/lS7+78Nlq0nweI+b+57NW2uey1dIDNMER7A9bgjHAn0Dq1agr8syj3B7JabkS+wL0=;
X-UUID: 85e8bf4af8164fee9720b06c6b768bef-20200302
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1409833056; Mon, 02 Mar 2020 17:11:42 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 2 Mar 2020 17:09:00 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 2 Mar 2020 17:11:08 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <ebiggers@kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>, <satyat@google.com>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <light.hsieh@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [RFC PATCH v1] scsi: ufs-mediatek: add inline encryption support
Date:   Mon, 2 Mar 2020 17:11:38 +0800
Message-ID: <20200302091138.10341-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1E0A8519FB5C75622F8B15201DA37225490402B846AFCF514B41CA5CB4FE07DC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

QWRkIGlubGluZSBlbmNyeXB0aW9uIHN1cHBvcnQgdG8gdWZzLW1lZGlhdGVrLg0KDQpUaGUgc3Rh
bmRhcmRzLWNvbXBsaWFudCBwYXJ0cywgc3VjaCBhcyBxdWVyeWluZyB0aGUgY3J5cHRvIGNhcGFi
aWxpdGllcw0KYW5kIGVuYWJsaW5nIGNyeXB0byBmb3IgaW5kaXZpZHVhbCBVRlMgcmVxdWVzdHMs
IGFyZSBhbHJlYWR5IGhhbmRsZWQgYnkNCnVmc2hjZC1jcnlwdG8uYywgd2hpY2ggaXRzZWxmIGlz
IHdpcmVkIGludG8gdGhlIGJsay1jcnlwdG8gZnJhbWV3b3JrLg0KDQpIb3dldmVyIE1lZGlhVGVr
IFVGUyBob3N0IHJlcXVpcmVzIGEgdmVuZG9yLXNwZWNpZmljIGhjZV9lbmFibGUgb3BlcmF0aW9u
DQp0byBhbGxvdyBjcnlwdG8tcmVsYXRlZCByZWdpc3RlcnMgYmVpbmcgYWNjZXNzZWQgbm9ybWFs
bHkgaW4ga2VybmVsLg0KQWZ0ZXIgdGhpcyBzdGVwLCBNZWRpYVRlayBVRlMgaG9zdCBjYW4gd29y
ayBhcyBzdGFuZGFyZC1jb21wbGlhbnQgaG9zdA0KZm9yIGlubGluZS1lbmNyeXB0aW9uIHJlbGF0
ZWQgZnVuY3Rpb25zLg0KDQpUaGlzIHBhdGNoIGlzIHJlYmFzZWQgdG8gdGhlIGxhdGVzdCB3aXAt
aW5saW5lLWVuY3J5cHRpb24gYnJhbmNoIGluDQpFcmljIEJpZ2dlcnMncyBnaXQ6DQpodHRwczov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9lYmlnZ2Vycy9saW51eC5n
aXQvDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMjcgKysrKysrKysr
KysrKysrKysrKysrKysrKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAx
ICsNCiAyIGZpbGVzIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA1M2VhZTVmZTJhZGUuLjEyZDAxZmQzZDVlMSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xNSw2ICsxNSw3IEBADQogI2luY2x1ZGUg
PGxpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oPg0KIA0KICNpbmNsdWRlICJ1ZnNoY2Qu
aCINCisjaW5jbHVkZSAidWZzaGNkLWNyeXB0by5oIg0KICNpbmNsdWRlICJ1ZnNoY2QtcGx0ZnJt
LmgiDQogI2luY2x1ZGUgInVmc19xdWlya3MuaCINCiAjaW5jbHVkZSAidW5pcHJvLmgiDQpAQCAt
MjQsNiArMjUsOSBAQA0KIAlhcm1fc21jY2Nfc21jKE1US19TSVBfVUZTX0NPTlRST0wsIFwNCiAJ
CSAgICAgIGNtZCwgdmFsLCAwLCAwLCAwLCAwLCAwLCAmKHJlcykpDQogDQorI2RlZmluZSB1ZnNf
bXRrX2NyeXB0b19jdHJsKHJlcywgZW5hYmxlKSBcDQorCXVmc19tdGtfc21jKFVGU19NVEtfU0lQ
X0NSWVBUT19DVFJMLCBlbmFibGUsIHJlcykNCisNCiAjZGVmaW5lIHVmc19tdGtfcmVmX2Nsa19u
b3RpZnkob24sIHJlcykgXA0KIAl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElG
SUNBVElPTiwgb24sIHJlcykNCiANCkBAIC02Niw3ICs3MCwyNyBAQCBzdGF0aWMgdm9pZCB1ZnNf
bXRrX2NmZ191bmlwcm9fY2coc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQogCX0N
CiB9DQogDQotc3RhdGljIGludCB1ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KK3N0YXRpYyB2b2lkIHVmc19tdGtfY3J5cHRvX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KK3sNCisJc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KKw0KKwl1ZnNfbXRrX2NyeXB0b19j
dHJsKHJlcywgMSk7DQorCWlmIChyZXMuYTApIHsNCisJCWRldl9pbmZvKGhiYS0+ZGV2LCAiJXM6
IGNyeXB0byBlbmFibGUgZmFpbGVkLCBlcnI6ICVsdVxuIiwNCisJCQkgX19mdW5jX18sIHJlcy5h
MCk7DQorCX0NCit9DQorDQorc3RhdGljIGludCB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0
cnVjdCB1ZnNfaGJhICpoYmEsDQorCQkJCSAgICAgZW51bSB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0
dXMgc3RhdHVzKQ0KK3sNCisJaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFICYmIHVmc2hjZF9oYmFf
aXNfY3J5cHRvX3N1cHBvcnRlZChoYmEpKQ0KKwkJdWZzX210a19jcnlwdG9fZW5hYmxlKGhiYSk7
DQorDQorCXJldHVybiAwOw0KK30NCisNCitpbnQgdWZzX210a19iaW5kX21waHkoc3RydWN0IHVm
c19oYmEgKmhiYSkNCiB7DQogCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0
X3ZhcmlhbnQoaGJhKTsNCiAJc3RydWN0IGRldmljZSAqZGV2ID0gaGJhLT5kZXY7DQpAQCAtNDk0
LDYgKzUxOCw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB1ZnNfaGJhX210
a192b3BzID0gew0KIAkubmFtZSAgICAgICAgICAgICAgICA9ICJtZWRpYXRlay51ZnNoY2kiLA0K
IAkuaW5pdCAgICAgICAgICAgICAgICA9IHVmc19tdGtfaW5pdCwNCiAJLnNldHVwX2Nsb2NrcyAg
ICAgICAgPSB1ZnNfbXRrX3NldHVwX2Nsb2NrcywNCisJLmhjZV9lbmFibGVfbm90aWZ5ICAgPSB1
ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5LA0KIAkubGlua19zdGFydHVwX25vdGlmeSA9IHVmc19t
dGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAgPSB1ZnNfbXRr
X3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuYXBwbHlfZGV2X3F1aXJrcyAgICA9IHVmc19tdGtfYXBw
bHlfZGV2X3F1aXJrcywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggZmNjZGQ5NzlkNmZi
Li41ZWJhYTU5ODk4YmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtNTgsNiArNTgs
NyBAQA0KICAqLw0KICNkZWZpbmUgTVRLX1NJUF9VRlNfQ09OVFJPTCAgICAgICAgICAgICAgIE1U
S19TSVBfU01DX0NNRCgweDI3NikNCiAjZGVmaW5lIFVGU19NVEtfU0lQX0RFVklDRV9SRVNFVCAg
ICAgICAgICBCSVQoMSkNCisjZGVmaW5lIFVGU19NVEtfU0lQX0NSWVBUT19DVFJMICAgICAgICAg
ICBCSVQoMikNCiAjZGVmaW5lIFVGU19NVEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FUSU9OICBCSVQo
MykNCiANCiAvKg0KLS0gDQoyLjE4LjANCg==

