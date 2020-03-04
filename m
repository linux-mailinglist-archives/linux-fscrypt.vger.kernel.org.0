Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3375178827
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 03:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgCDCVb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 Mar 2020 21:21:31 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51183 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387400AbgCDCVa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 Mar 2020 21:21:30 -0500
X-UUID: dbc3c446a699493cab4b5666f1c37bf2-20200304
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Dm2V6GDWvlxQSEubyRoFN1pLie+rFhFwHaZFOLLiCqw=;
        b=iyv4DQGAgUhykmexFoEHsa+5g7ZRs/voyb4EhescE6Mha12o3MgyFqBvQbWDpv2bX9/hDyD2MqAfQRwzUO7iTdekXVy76Do0Hh6kp7gsh4D4AUuP7C5mKI0WkxitFUWpUufYBLcIMV1KZo/dgRTv/l+Ewpf1ZHmKTzLmUQjFdn8=;
X-UUID: dbc3c446a699493cab4b5666f1c37bf2-20200304
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 947991880; Wed, 04 Mar 2020 10:21:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 4 Mar 2020 10:18:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 4 Mar 2020 10:18:44 +0800
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
Subject: [RFC PATCH v2] scsi: ufs-mediatek: add inline encryption support
Date:   Wed, 4 Mar 2020 10:21:02 +0800
Message-ID: <20200304022101.14165-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6FCB616A2934E695AB18D81FA70BEAADA050A97D3BDBD961B702E6F8CF1085B92000:8
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
ZWQgZnVuY3Rpb25zLg0KDQpUaGlzIHBhdGNoIGlzIHJlYmFzZWQgdG8gYmVsb3cgcmVwbyBhbmQg
dGFnOg0KCVJlcG86IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy9mc2NyeXB0L2Zz
Y3J5cHQuZ2l0DQoJVGFnOiBpbmxpbmUtZW5jcnlwdGlvbi12Nw0KDQpTaWduZWQtb2ZmLWJ5OiBT
dGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KIGRy
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgMSArDQogMiBmaWxlcyBjaGFuZ2VkLCAy
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0K
aW5kZXggNTNlYWU1ZmUyYWRlLi4xMmQwMWZkM2Q1ZTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQpAQCAtMTUsNiArMTUsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9zb2MvbWVkaWF0ZWsvbXRr
X3NpcF9zdmMuaD4NCiANCiAjaW5jbHVkZSAidWZzaGNkLmgiDQorI2luY2x1ZGUgInVmc2hjZC1j
cnlwdG8uaCINCiAjaW5jbHVkZSAidWZzaGNkLXBsdGZybS5oIg0KICNpbmNsdWRlICJ1ZnNfcXVp
cmtzLmgiDQogI2luY2x1ZGUgInVuaXByby5oIg0KQEAgLTI0LDYgKzI1LDkgQEANCiAJYXJtX3Nt
Y2NjX3NtYyhNVEtfU0lQX1VGU19DT05UUk9MLCBcDQogCQkgICAgICBjbWQsIHZhbCwgMCwgMCwg
MCwgMCwgMCwgJihyZXMpKQ0KIA0KKyNkZWZpbmUgdWZzX210a19jcnlwdG9fY3RybChyZXMsIGVu
YWJsZSkgXA0KKwl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9DUllQVE9fQ1RSTCwgZW5hYmxlLCBy
ZXMpDQorDQogI2RlZmluZSB1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMpIFwNCiAJdWZz
X210a19zbWMoVUZTX01US19TSVBfUkVGX0NMS19OT1RJRklDQVRJT04sIG9uLCByZXMpDQogDQpA
QCAtNjYsNyArNzAsMjcgQEAgc3RhdGljIHZvaWQgdWZzX210a19jZmdfdW5pcHJvX2NnKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0KIAl9DQogfQ0KIA0KLXN0YXRpYyBpbnQgdWZz
X210a19iaW5kX21waHkoc3RydWN0IHVmc19oYmEgKmhiYSkNCitzdGF0aWMgdm9pZCB1ZnNfbXRr
X2NyeXB0b19lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXN0cnVjdCBhcm1fc21j
Y2NfcmVzIHJlczsNCisNCisJdWZzX210a19jcnlwdG9fY3RybChyZXMsIDEpOw0KKwlpZiAocmVz
LmEwKSB7DQorCQlkZXZfaW5mbyhoYmEtPmRldiwgIiVzOiBjcnlwdG8gZW5hYmxlIGZhaWxlZCwg
ZXJyOiAlbHVcbiIsDQorCQkJIF9fZnVuY19fLCByZXMuYTApOw0KKwl9DQorfQ0KKw0KK3N0YXRp
YyBpbnQgdWZzX210a19oY2VfZW5hYmxlX25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KKwkJ
CQkgICAgIGVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykNCit7DQorCWlmIChz
dGF0dXMgPT0gUFJFX0NIQU5HRSAmJiB1ZnNoY2RfaGJhX2lzX2NyeXB0b19zdXBwb3J0ZWQoaGJh
KSkNCisJCXVmc19tdGtfY3J5cHRvX2VuYWJsZShoYmEpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQor
DQoraW50IHVmc19tdGtfYmluZF9tcGh5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlzdHJ1
Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQogCXN0cnVj
dCBkZXZpY2UgKmRldiA9IGhiYS0+ZGV2Ow0KQEAgLTQ5NCw2ICs1MTgsNyBAQCBzdGF0aWMgc3Ry
dWN0IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJLm5hbWUgICAg
ICAgICAgICAgICAgPSAibWVkaWF0ZWsudWZzaGNpIiwNCiAJLmluaXQgICAgICAgICAgICAgICAg
PSB1ZnNfbXRrX2luaXQsDQogCS5zZXR1cF9jbG9ja3MgICAgICAgID0gdWZzX210a19zZXR1cF9j
bG9ja3MsDQorCS5oY2VfZW5hYmxlX25vdGlmeSAgID0gdWZzX210a19oY2VfZW5hYmxlX25vdGlm
eSwNCiAJLmxpbmtfc3RhcnR1cF9ub3RpZnkgPSB1ZnNfbXRrX2xpbmtfc3RhcnR1cF9ub3RpZnks
DQogCS5wd3JfY2hhbmdlX25vdGlmeSAgID0gdWZzX210a19wd3JfY2hhbmdlX25vdGlmeSwNCiAJ
LmFwcGx5X2Rldl9xdWlya3MgICAgPSB1ZnNfbXRrX2FwcGx5X2Rldl9xdWlya3MsDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmgNCmluZGV4IGZjY2RkOTc5ZDZmYi4uNWViYWE1OTg5OGJmIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaA0KQEAgLTU4LDYgKzU4LDcgQEANCiAgKi8NCiAjZGVmaW5lIE1U
S19TSVBfVUZTX0NPTlRST0wgICAgICAgICAgICAgICBNVEtfU0lQX1NNQ19DTUQoMHgyNzYpDQog
I2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQgICAgICAgICAgQklUKDEpDQorI2RlZmlu
ZSBVRlNfTVRLX1NJUF9DUllQVE9fQ1RSTCAgICAgICAgICAgQklUKDIpDQogI2RlZmluZSBVRlNf
TVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiAgQklUKDMpDQogDQogLyoNCi0tIA0KMi4xOC4w
DQo=

