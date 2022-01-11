Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7848B543
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345542AbiAKSGb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:06:31 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4402 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345411AbiAKSEC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:04:02 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJQ13qZMz688Bk;
        Wed, 12 Jan 2022 02:00:25 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:58 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 14/14] KEYS: Introduce load_pgp_public_keyring()
Date:   Tue, 11 Jan 2022 19:03:18 +0100
Message-ID: <20220111180318.591029-15-roberto.sassu@huawei.com>
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

Preload PGP keys from 'pubring.gpg', placed in certs/ of the kernel source
directory.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 certs/Kconfig               | 11 +++++++++++
 certs/Makefile              |  7 +++++++
 certs/system_certificates.S | 18 ++++++++++++++++++
 certs/system_keyring.c      | 21 +++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/certs/Kconfig b/certs/Kconfig
index ae7f2e876a31..2f7fa68cd958 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -126,4 +126,15 @@ config SYSTEM_REVOCATION_KEYS
 	  containing X.509 certificates to be included in the default blacklist
 	  keyring.
 
+config PGP_PRELOAD_PUBLIC_KEYS
+	bool "Preload PGP public keys"
+	depends on SYSTEM_TRUSTED_KEYRING
+	select PGP_PRELOAD
+	default n
+	help
+	  Load at boot time the PGP public keys from a reserved area (populated
+	  with the content of 'certs/pubring.gpg' provided at kernel build
+	  time), and add them to the built-in keyring. Invalid keys are ignored
+	  and the loading continues.
+
 endmenu
diff --git a/certs/Makefile b/certs/Makefile
index 279433783b10..c85e0ff560ca 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -22,6 +22,13 @@ $(obj)/system_certificates.o: $(obj)/x509_certificate_list
 # Cope with signing_key.x509 existing in $(srctree) not $(objtree)
 AFLAGS_system_certificates.o := -I$(srctree)
 
+ifdef CONFIG_PGP_PRELOAD_PUBLIC_KEYS
+ifeq ($(shell ls $(srctree)/certs/pubring.gpg 2> /dev/null), $(srctree)/certs/pubring.gpg)
+AFLAGS_system_certificates.o += -DHAVE_PUBRING_GPG
+$(obj)/system_certificates.o: $(srctree)/certs/pubring.gpg
+endif
+endif
+
 quiet_cmd_extract_certs  = EXTRACT_CERTS   $(patsubst "%",%,$(2))
       cmd_extract_certs  = scripts/extract-cert $(2) $@
 
diff --git a/certs/system_certificates.S b/certs/system_certificates.S
index e1645e6f4d97..03b361bec758 100644
--- a/certs/system_certificates.S
+++ b/certs/system_certificates.S
@@ -47,3 +47,21 @@ module_cert_size:
 #else
 	.long __module_cert_end - __module_cert_start
 #endif
+
+	.align 8
+	.globl pgp_public_keys
+pgp_public_keys:
+__pgp_key_list_start:
+#ifdef HAVE_PUBRING_GPG
+	.incbin "certs/pubring.gpg"
+#endif
+__pgp_key_list_end:
+
+	.align 8
+	.globl pgp_public_keys_size
+pgp_public_keys_size:
+#ifdef CONFIG_64BIT
+	.quad __pgp_key_list_end - __pgp_key_list_start
+#else
+	.long __pgp_key_list_end - __pgp_key_list_start
+#endif
diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 26a11b1dcd59..1612fb97a652 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -167,6 +167,27 @@ static __init int load_system_certificate_list(void)
 }
 late_initcall(load_system_certificate_list);
 
+#ifdef CONFIG_PGP_PRELOAD_PUBLIC_KEYS
+extern __initconst const u8 pgp_public_keys[];
+extern __initconst const unsigned long pgp_public_keys_size;
+
+/*
+ * Load a list of PGP keys.
+ */
+static __init int load_pgp_public_keyring(void)
+{
+	pr_notice("Load PGP public keys\n");
+
+	if (preload_pgp_keys(pgp_public_keys,
+			     pgp_public_keys_size,
+			     builtin_trusted_keys) < 0)
+		pr_err("Can't load PGP public keys\n");
+
+	return 0;
+}
+late_initcall(load_pgp_public_keyring);
+#endif /* CONFIG_PGP_PRELOAD_PUBLIC_KEYS */
+
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 /**
-- 
2.32.0

