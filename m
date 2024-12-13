Return-Path: <linux-fscrypt+bounces-571-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8539F0439
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 06:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8152161E1A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0A6188A0C;
	Fri, 13 Dec 2024 05:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agsu2Sev"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7918893C;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067736; cv=none; b=JKezI1sb6oJ+agxJHHL/s5Wifm6IpKU6oiEMHxNI9ISLWo9FGSV/NGrdNK8IMJiu3c8ZC+HAlgYZiDpD7UlowyhJktFWtAaZHKqxCmz61Z7LWzWwby8hqqEI284NWXidF4a1fvjUeQGy+CkNpN8aeYG8luWsTy0PCoJODs3k+98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067736; c=relaxed/simple;
	bh=LMj6vrPETXA4uFxujgB3lvJ+v75BVZ8LjhTWGIMzEX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApUqPy3TuYVv8ITJolQB33sthh42yuJ8QNifCipcBsMRvZXar9R7n3F9YQd8KhfZj3gq1BG7kb0vEQDLde686DnpGBIHvudqVUn5cKjmCqzyJ8U00cHx0gJiP2GMRo+hd14FR5Qkjhv/gROksL7aKiejsCrgsF/povHojGWvMes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agsu2Sev; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76266C4CED1;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734067736;
	bh=LMj6vrPETXA4uFxujgB3lvJ+v75BVZ8LjhTWGIMzEX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agsu2SevZPOqZATvUxhRUeJ/daRcx+vLXJNsk6if3W4IlhzhEmKyK/P5VmP5plBj3
	 4G0Z5Rkp786TXT3P3IkozY3BOIyrrL4Ia5bHeF29cQddmHm7L0kt4qLniMGs4xVV6f
	 3YIib6/yGBiNhSPY3bZ/nTI19hvAJDxatMhk1lFpuqJxCC+RIYJG3qBxOjtck9HUET
	 TEV9Zq5+SocxgPHxmlSWzDDR3neqDNBT2Fp1qiG5YYQX4MPRjjGeNioRRW6WG8Xrxn
	 4yx434wjpjB09qeOEgdj4SssZxrImpPOqieztfdthuOaDyc+0aohbvUUmEE72HZiiT
	 hvcFyvJAsi0TA==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 3/3] generic: verify ciphertext with hardware-wrapped keys
Date: Thu, 12 Dec 2024 21:28:39 -0800
Message-ID: <20241213052840.314921-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213052840.314921-1-ebiggers@kernel.org>
References: <20241213052840.314921-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add two tests which verify that encrypted files are encrypted correctly
when a hardware-wrapped inline encryption key is used.  The two tests
are identical except that one uses FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64
and the other uses FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32.  These cover both
of the settings where hardware-wrapped keys may be used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/900     | 24 ++++++++++++++++++++++++
 tests/generic/900.out |  6 ++++++
 tests/generic/901     | 24 ++++++++++++++++++++++++
 tests/generic/901.out |  6 ++++++
 4 files changed, 60 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..8da8007e
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,24 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2024 Google LLC
+#
+# FS QA Test No. 900
+#
+# Verify the ciphertext for encryption policies that use a hardware-wrapped
+# inline encryption key, the IV_INO_LBLK_64 flag, and AES-256-XTS.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+. ./common/filter
+. ./common/encrypt
+
+# Hardware-wrapped keys require the inlinecrypt mount option.
+_require_scratch_inlinecrypt
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o inlinecrypt"
+
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC \
+	v2 iv_ino_lblk_64 hw_wrapped_key
+
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..9edc012c
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,6 @@
+QA output created by 900
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 iv_ino_lblk_64 hw_wrapped_key
diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100755
index 00000000..bfc63bde
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,24 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2024 Google LLC
+#
+# FS QA Test No. 901
+#
+# Verify the ciphertext for encryption policies that use a hardware-wrapped
+# inline encryption key, the IV_INO_LBLK_32 flag, and AES-256-XTS.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+. ./common/filter
+. ./common/encrypt
+
+# Hardware-wrapped keys require the inlinecrypt mount option.
+_require_scratch_inlinecrypt
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o inlinecrypt"
+
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC \
+	v2 iv_ino_lblk_32 hw_wrapped_key
+
+status=0
+exit
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 00000000..2f928465
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,6 @@
+QA output created by 901
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 iv_ino_lblk_32 hw_wrapped_key
-- 
2.47.1


