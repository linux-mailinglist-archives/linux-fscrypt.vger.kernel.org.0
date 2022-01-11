Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5094248B4EA
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350138AbiAKSEH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:07 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4397 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345541AbiAKSD5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:57 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJV00fWQz67ykV;
        Wed, 12 Jan 2022 02:03:52 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:54 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 09/14] KEYS: Retry asym key search with partial ID in restrict_link_by_signature()
Date:   Tue, 11 Jan 2022 19:03:13 +0100
Message-ID: <20220111180318.591029-10-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111180318.591029-1-roberto.sassu@huawei.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Retry asymmetric key search in restrict_link_by_signature() to support the
case of partial IDs, provided by PGP signatures (only the last 8 bytes).

Although recently draft-ietf-openpgp-rfc4880bis-10 supports the signature
subpacket type 33, which contains the full issuer fingerprint, we cannot
rely on existing signatures to support it.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/restrict.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index 84cefe3b3585..f1ad1862ee9d 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -97,8 +97,14 @@ int restrict_link_by_signature(struct key *dest_keyring,
 	key = find_asymmetric_key(trust_keyring,
 				  sig->auth_ids[0], sig->auth_ids[1],
 				  false);
-	if (IS_ERR(key))
-		return -ENOKEY;
+	if (IS_ERR(key)) {
+		/* Retry with a partial ID. */
+		key = find_asymmetric_key(trust_keyring,
+					  sig->auth_ids[0], sig->auth_ids[1],
+					  true);
+		if (IS_ERR(key))
+			return -ENOKEY;
+	}
 
 	if (use_builtin_keys && !test_bit(KEY_FLAG_BUILTIN, &key->flags))
 		ret = -ENOKEY;
-- 
2.32.0

