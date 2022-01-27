Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B1549EA8C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbiA0Sqi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:38 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4536 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbiA0Sqd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:33 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8gL2wx5z67M3D;
        Fri, 28 Jan 2022 02:46:06 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:31 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 10/11] evm: Include fsverity formatted digest in the HMAC/digest calculation
Date:   Thu, 27 Jan 2022 19:46:14 +0100
Message-ID: <20220127184614.2837938-6-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127184614.2837938-1-roberto.sassu@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
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

Include the fsverity formatted digest in the HMAC/diget calculation. It can
be a substitute of the IMA xattr for binding the EVM HMAC/signature to the
file content.

This feature is disabled by default, and must be enabled in the kernel
configuration.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/evm.h                 |  4 ++++
 security/integrity/evm/Kconfig      | 15 +++++++++++++++
 security/integrity/evm/evm_crypto.c | 18 ++++++++++++++++++
 security/integrity/evm/evm_main.c   |  4 ++++
 4 files changed, 41 insertions(+)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 3da25393b011..e6637dfb22fe 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -16,7 +16,11 @@ struct integrity_iint_cache;
 
 static inline bool evm_protects_fsverity(void)
 {
+#ifdef CONFIG_EVM_ATTR_FSVERITY
+	return true;
+#else
 	return false;
+#endif
 }
 
 #ifdef CONFIG_EVM
diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index a6e19d23e700..837308dacede 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -27,6 +27,21 @@ config EVM_ATTR_FSUUID
 	  additional info to the calculation, requires existing EVM
 	  labeled file systems to be relabeled.
 
+config EVM_ATTR_FSVERITY
+	bool "Include fsverity formatted digest"
+	default n
+	depends on EVM
+	depends on FS_VERITY
+	help
+	  Include fsverity formatted digest for HMAC/digest calculation.
+
+	  Default value is 'not selected'.
+
+	  WARNING: changing the HMAC/digest calculation method or adding
+	  additional info to the calculation, requires existing EVM
+	  labeled file systems to be relabeled, and the signatures to be
+	  replaced.
+
 config EVM_EXTRA_SMACK_XATTRS
 	bool "Additional SMACK xattrs"
 	depends on EVM && SECURITY_SMACK
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 0450d79afdc8..5da427d8b2c7 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -16,6 +16,7 @@
 #include <linux/crypto.h>
 #include <linux/xattr.h>
 #include <linux/evm.h>
+#include <linux/fsverity.h>
 #include <keys/encrypted-type.h>
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
@@ -224,6 +225,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	int error;
 	int size, user_space_size;
 	bool ima_present = false;
+	u8 fsverity_fmt_digest[FS_VERITY_MAX_FMT_DIGEST_SIZE];
+	ssize_t fsverity_fmt_digest_len;
+	enum hash_algo fsverity_algo;
 
 	if (!(inode->i_opflags & IOP_XATTR) ||
 	    inode->i_sb->s_user_ns != &init_user_ns)
@@ -296,6 +300,20 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 			dump_security_xattr(xattr->name, xattr_value,
 					    xattr_size);
 	}
+
+	if (IS_ENABLED(CONFIG_EVM_ATTR_FSVERITY)) {
+		fsverity_fmt_digest_len = fsverity_get_formatted_digest(inode,
+							fsverity_fmt_digest,
+							&fsverity_algo);
+		if (fsverity_fmt_digest_len > 0) {
+			crypto_shash_update(desc, fsverity_fmt_digest,
+					    fsverity_fmt_digest_len);
+			/* Fsverity formatted digest satisfies this req. */
+			ima_present = true;
+			error = 0;
+		}
+	}
+
 	hmac_add_misc(desc, inode, type, data->digest);
 
 	/* Portable EVM signatures must include an IMA hash */
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 08f907382c61..8943bf4abc62 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -108,6 +108,10 @@ static void __init evm_init_config(void)
 #ifdef CONFIG_EVM_ATTR_FSUUID
 	evm_hmac_attrs |= EVM_ATTR_FSUUID;
 #endif
+
+	if (IS_ENABLED(CONFIG_EVM_ATTR_FSVERITY))
+		pr_info("Fsverity formatted digest included in calculation\n");
+
 	pr_info("HMAC attrs: 0x%x\n", evm_hmac_attrs);
 }
 
-- 
2.32.0

