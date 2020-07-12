Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C0B21C6D8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2020 02:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgGLAe5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 11 Jul 2020 20:34:57 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:8042 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727063AbgGLAe5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 11 Jul 2020 20:34:57 -0400
X-UUID: f9e2529fb90549f09fd52c812c201b53-20200712
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=n3sNpYiLmKaGsJfthLW62RYEg3Nma2G80CSDm3G+WZw=;
        b=Pb5wRf5unXe45znaK4ZQ6rfHSOGfIBLTX9dHlBxdIvoNW2goUiqXWXNIWABMGRzAfENMGMy/F7Q/3IYKtqMFrYF+E8GfAB6r/n/mE48oOi9yqBhVAbmsfuUFSj5IaXji6KYhDsZNuwOH/oHC4zrZbqu+ibtZ0oUIFQm6UPTD3uE=;
X-UUID: f9e2529fb90549f09fd52c812c201b53-20200712
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2062629021; Sun, 12 Jul 2020 08:34:53 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 12 Jul 2020 08:34:45 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 08:34:45 +0800
Message-ID: <1594514085.10600.5.camel@mtkswgap22>
Subject: Re: [RFC PATCH v2] scsi: ufs-mediatek: add inline encryption support
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
Date:   Sun, 12 Jul 2020 08:34:45 +0800
In-Reply-To: <20200710063920.GD2805@sol.localdomain>
References: <20200304022101.14165-1-stanley.chu@mediatek.com>
         <20200710063920.GD2805@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: DBA37B226ABF5071E1BA737E04B4A839B2BD8511C427FF6EECB7C92A7EC944282000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SGkgRXJpYywNCg0KT24gVGh1LCAyMDIwLTA3LTA5IGF0IDIzOjM5IC0wNzAwLCBFcmljIEJpZ2dl
cnMgd3JvdGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAx
MDoyMTowMkFNICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4gPiBBZGQgaW5saW5lIGVuY3J5
cHRpb24gc3VwcG9ydCB0byB1ZnMtbWVkaWF0ZWsuDQo+ID4gDQo+ID4gVGhlIHN0YW5kYXJkcy1j
b21wbGlhbnQgcGFydHMsIHN1Y2ggYXMgcXVlcnlpbmcgdGhlIGNyeXB0byBjYXBhYmlsaXRpZXMN
Cj4gPiBhbmQgZW5hYmxpbmcgY3J5cHRvIGZvciBpbmRpdmlkdWFsIFVGUyByZXF1ZXN0cywgYXJl
IGFscmVhZHkgaGFuZGxlZCBieQ0KPiA+IHVmc2hjZC1jcnlwdG8uYywgd2hpY2ggaXRzZWxmIGlz
IHdpcmVkIGludG8gdGhlIGJsay1jcnlwdG8gZnJhbWV3b3JrLg0KPiA+IA0KPiA+IEhvd2V2ZXIg
TWVkaWFUZWsgVUZTIGhvc3QgcmVxdWlyZXMgYSB2ZW5kb3Itc3BlY2lmaWMgaGNlX2VuYWJsZSBv
cGVyYXRpb24NCj4gPiB0byBhbGxvdyBjcnlwdG8tcmVsYXRlZCByZWdpc3RlcnMgYmVpbmcgYWNj
ZXNzZWQgbm9ybWFsbHkgaW4ga2VybmVsLg0KPiA+IEFmdGVyIHRoaXMgc3RlcCwgTWVkaWFUZWsg
VUZTIGhvc3QgY2FuIHdvcmsgYXMgc3RhbmRhcmQtY29tcGxpYW50IGhvc3QNCj4gPiBmb3IgaW5s
aW5lLWVuY3J5cHRpb24gcmVsYXRlZCBmdW5jdGlvbnMuDQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBp
cyByZWJhc2VkIHRvIGJlbG93IHJlcG8gYW5kIHRhZzoNCj4gPiAJUmVwbzogaHR0cHM6Ly91cmxk
ZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy9mc2NyeXB0
L2ZzY3J5cHQuZ2l0X187ISFDVFJOS0E5d01nMEFSYncheDhLbHRjdThBUWhkdGxJRFhBU1dqZF9B
TnJCdGNZemlkSVhNc3UtZlFsb0VxZ3ZyRERCVTl5RDlHdW10S0xJY2RfYyQgDQo+ID4gCVRhZzog
aW5saW5lLWVuY3J5cHRpb24tdjcNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgMSArDQo+ID4gIDIgZmlsZXMgY2hh
bmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gTm93IHRoYXQgdGhl
IHVmc2hjZC1jcnlwdG8gcGF0Y2hlcyB0aGlzIGRlcGVuZHMgb24gYXJlIGluIDUuOS9zY3NpLXF1
ZXVlLCBjb3VsZA0KPiB5b3UgcmV0ZXN0IGFuZCByZXNlbmQgdGhpcyBwYXRjaD8gIEl0IHdvdWxk
IGJlIG5pY2UgdG8gaGF2ZSA1Ljkgc3VwcG9ydCBzb21lDQo+IHJlYWwgaGFyZHdhcmUgYWxyZWFk
eS4gIChJJ20gZ29pbmcgdG8gcmVzZW5kIG15IHBhdGNoc2V0IGZvciB1ZnMtcWNvbSB0b28uKQ0K
DQpTdXJlLiBOb3cgdGhpcyBwYXRjaCBpcyByZXNlbnQgYXMgdjMsIHBsZWFzZSBzZWUNCmh0dHBz
Oi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTE2NTc5ODcvDQoNClRoYW5rcywNClN0YW5s
ZXkgQ2h1DQoNCg==

