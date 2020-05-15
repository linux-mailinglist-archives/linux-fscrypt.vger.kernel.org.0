Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64F71D444A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 06:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgEOENo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 00:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgEOENo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 00:13:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF23920722;
        Fri, 15 May 2020 04:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589516022;
        bh=YOeXSo1nD7Cff4TitOtBQYKFBWlSnRt/ffT4QZRYUZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRFr073lSgyTKhNO9OQ+vCJ1QOroMPVA2g+7MWDBuTS1USF1vwZ7bD1l84umVINz3
         5n4KZotx0rzTkB3CG7GflEJA6sY+XPBehzuFgoEhQ4tAOKvVCzfcn/YF6KDVcGfZMD
         04XpTciKUCMQXDwLJyWOAn0skdBpGITehsXrR4OM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: [PATCH 3/3] Add some basic test programs for libfsverity
Date:   Thu, 14 May 2020 21:10:42 -0700
Message-Id: <20200515041042.267966-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515041042.267966-1-ebiggers@kernel.org>
References: <20200515041042.267966-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add three test programs: 'test_hash_algs', 'test_compute_digest', and
'test_sign_digest'.  Nothing fancy yet, just some basic tests to test
each library function.

With the new Makefile, these get run by 'make check'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/test_compute_digest.c |  54 +++++++++++++++++++++++++++++++++
 programs/test_hash_algs.c      |  27 +++++++++++++++++
 programs/test_sign_digest.c    |  44 +++++++++++++++++++++++++++
 testdata/cert.pem              |  31 +++++++++++++++++++
 testdata/file.sig              | Bin 0 -> 708 bytes
 testdata/key.pem               |  52 +++++++++++++++++++++++++++++++
 6 files changed, 208 insertions(+)
 create mode 100644 programs/test_compute_digest.c
 create mode 100644 programs/test_hash_algs.c
 create mode 100644 programs/test_sign_digest.c
 create mode 100644 testdata/cert.pem
 create mode 100644 testdata/file.sig
 create mode 100644 testdata/key.pem

diff --git a/programs/test_compute_digest.c b/programs/test_compute_digest.c
new file mode 100644
index 0000000..5d00576
--- /dev/null
+++ b/programs/test_compute_digest.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "utils.h"
+
+struct file {
+	u8 *data;
+	size_t size;
+	size_t offset;
+};
+
+static int read_fn(void *fd, void *buf, size_t count)
+{
+	struct file *f = fd;
+
+	ASSERT(count <= f->size - f->offset);
+	memcpy(buf, &f->data[f->offset], count);
+	f->offset += count;
+	return 0;
+}
+
+int main(void)
+{
+	struct file f = { .size = 1000000 };
+	size_t i;
+	const struct libfsverity_merkle_tree_params params = {
+		.version = 1,
+		.hash_algorithm = FS_VERITY_HASH_ALG_SHA256,
+		.block_size = 4096,
+		.salt_size = 4,
+		.salt = (u8 *)"abcd",
+		.file_size = f.size,
+	};
+	struct libfsverity_digest *d;
+	static const u8 expected_digest[32] =
+		"\x91\x79\x00\xb0\xd2\x99\x45\x4a\xa3\x04\xd5\xde\xbc\x6f\x39"
+		"\xe4\xaf\x7b\x5a\xbe\x33\xbd\xbc\x56\x8d\x5d\x8f\x1e\x5c\x4d"
+		"\x86\x52";
+	int err;
+
+	f.data = xmalloc(f.size);
+	for (i = 0; i < f.size; i++)
+		f.data[i] = (i % 11) + (i % 439) + (i % 1103);
+
+	err = libfsverity_compute_digest(&f, read_fn, &params, &d);
+	ASSERT(err == 0);
+
+	ASSERT(d->digest_algorithm == FS_VERITY_HASH_ALG_SHA256);
+	ASSERT(d->digest_size == 32);
+	ASSERT(!memcmp(d->digest, expected_digest, 32));
+
+	free(f.data);
+	free(d);
+	printf("test_compute_digest passed\n");
+	return 0;
+}
diff --git a/programs/test_hash_algs.c b/programs/test_hash_algs.c
new file mode 100644
index 0000000..b7db2ac
--- /dev/null
+++ b/programs/test_hash_algs.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "utils.h"
+
+int main(void)
+{
+	ASSERT(libfsverity_digest_size(0) == -1);
+	ASSERT(libfsverity_hash_name(0) == NULL);
+	ASSERT(libfsverity_find_hash_alg_by_name("bad") == 0);
+
+	ASSERT(libfsverity_digest_size(100) == -1);
+	ASSERT(libfsverity_hash_name(100) == NULL);
+
+	ASSERT(libfsverity_digest_size(FS_VERITY_HASH_ALG_SHA256) == 32);
+	ASSERT(!strcmp("sha256",
+		       libfsverity_hash_name(FS_VERITY_HASH_ALG_SHA256)));
+	ASSERT(libfsverity_find_hash_alg_by_name("sha256") ==
+	       FS_VERITY_HASH_ALG_SHA256);
+
+	ASSERT(libfsverity_digest_size(FS_VERITY_HASH_ALG_SHA512) == 64);
+	ASSERT(!strcmp("sha512",
+		       libfsverity_hash_name(FS_VERITY_HASH_ALG_SHA512)));
+	ASSERT(libfsverity_find_hash_alg_by_name("sha512") ==
+	       FS_VERITY_HASH_ALG_SHA512);
+
+	printf("test_hash_algs passed\n");
+	return 0;
+}
diff --git a/programs/test_sign_digest.c b/programs/test_sign_digest.c
new file mode 100644
index 0000000..0a97865
--- /dev/null
+++ b/programs/test_sign_digest.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "utils.h"
+
+#include <fcntl.h>
+
+int main(void)
+{
+	struct libfsverity_digest *d = xzalloc(sizeof(*d) + 32);
+	u8 *sig;
+	size_t sig_size;
+	struct libfsverity_signature_params params = {
+		.keyfile = "testdata/key.pem",
+		.certfile = "testdata/cert.pem",
+	};
+	struct filedes file;
+	u8 *expected_sig;
+	u64 expected_sig_size;
+	int err;
+
+	d->digest_algorithm = FS_VERITY_HASH_ALG_SHA256;
+	d->digest_size = 32;
+	memcpy(d->digest,
+	       "\x91\x79\x00\xb0\xd2\x99\x45\x4a\xa3\x04\xd5\xde\xbc\x6f\x39"
+	       "\xe4\xaf\x7b\x5a\xbe\x33\xbd\xbc\x56\x8d\x5d\x8f\x1e\x5c\x4d"
+	       "\x86\x52", 32);
+
+	err = libfsverity_sign_digest(d, &params, &sig, &sig_size);
+	ASSERT(err == 0);
+
+	ASSERT(open_file(&file, "testdata/file.sig", O_RDONLY, 0));
+	ASSERT(get_file_size(&file, &expected_sig_size));
+	ASSERT(sig_size == expected_sig_size);
+	expected_sig = xmalloc(sig_size);
+	ASSERT(full_read(&file, expected_sig, sig_size));
+	ASSERT(!memcmp(sig, expected_sig, sig_size));
+
+	free(d);
+	free(sig);
+	free(expected_sig);
+	filedes_close(&file);
+	printf("test_sign_digest passed\n");
+	return 0;
+}
+
diff --git a/testdata/cert.pem b/testdata/cert.pem
new file mode 100644
index 0000000..c63b965
--- /dev/null
+++ b/testdata/cert.pem
@@ -0,0 +1,31 @@
+-----BEGIN CERTIFICATE-----
+MIIFazCCA1OgAwIBAgIUYaRYcyZGDIv9fIxx/RoJwQu23+owDQYJKoZIhvcNAQEL
+BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
+GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMDA1MTUwMjUyMzFaFw0yMDA2
+MTQwMjUyMzFaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
+HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggIiMA0GCSqGSIb3DQEB
+AQUAA4ICDwAwggIKAoICAQC5lXk9otBz/VM/tbvBBK6sK//HE+q3ctY4+fPVv3Ob
+D1YNYuWRD59U+7K8fVUfZlXyjgxt3n4VPzkLgRSr/w5YUTa5NEOVJIltKT4ugswL
+5oY8eRVSuIr1O+vTbu+EpUk3DhTaFkalVzwspwipBeiVTDO9kh0NAueRk2HyLJte
+IoPyfzSCKxg9sED6/WtLFqrhDb5+1qeGoMNGM66ueWXKX0QjomMEODGXC04ypIY3
+sTwB+sYhZUe3YRpY0HyaVNh/6cxCxSiKr2jkC5UL+ry+46EJerNZbKmeqqyqmhXh
+P2cHv8MO91zdH1xbXUUenLcdpK/0oq+/sTAVV1/qPvnAofpN8tdZdrH65JD753jt
+s+lH/f0iGuKAb9ZpLOTM2d3wjY13OcHElj0zu2Usw9PXQpTK/DYlbcapOI4NTVyU
+NpK3yP4i5dPnkHoxpjLWz75Eq6gP9ZXohGq3YG0LxtvELWfaFmpzEUTlD59hJJOZ
+ELGxAXzsxLbelX/EmpX+GIqnFBpdMIuPO4HEfJwD5IcdeHqGl2iH9LIqsY5DcGj4
+hnqYplIYYk5mWgbhkexRbJIGNdn8WyXlraVp2MoSr3p7xJbmo0qYRRtt3kQShzDG
+0FrZX7wqxemc/g/hr+g2xqMQj0nYLehDeodqxA2n9grDUr4AdgQyxXDMUkGZdrg3
+cwIDAQABo1MwUTAdBgNVHQ4EFgQUxpaj6YjgLFyh9UVM71hf18cb/hkwHwYDVR0j
+BBgwFoAUxpaj6YjgLFyh9UVM71hf18cb/hkwDwYDVR0TAQH/BAUwAwEB/zANBgkq
+hkiG9w0BAQsFAAOCAgEAQnXMCgI+eSjK+l3nrpE+TRrXZhHeB0aT3gilVtBqFM95
+GxkLzOgJnW4SU+BCKTiGjwhCEXQiFj6UNDrI7vaNzmurI370uqmC9/pwKn4/L27V
+ToqLHk5d8kmvjSJyfgY/9H73srzHjNcqLG3uy+JP3/fIzaUzy7x9OUJtzdH19zic
+b61kCbqe6TJrlpL0Y50FY91QTzupsIS9IsAAeYXrJiEwpkXv/O9c51swtGZmQhVD
+TDn4B2aKOHecR+gKZQbPcuwTCbNLDRRPT4q0IM9yKjUxIM8vkAaxlrW3O7fgqUV0
+GU3/i0zZugq2XEludF3VelrqMUhSMqaREAtRUe3ufipwEsovDa43Hr9P6bINAfU3
+92Kv6adgeKZc4DmuEg6sFje/ET85teioHtwmjviJu6vnkbZg7x+IU01Y6YHboz/z
+hTAjz9g6owgdsbTG9nptvgJllY83zBtnAGOqhJLNVZ+TC3pbbKht/7sT+s+WP2+K
+81oZ3gmxIr6myMVyR5CCt+FNJ1hFxYNBJDao35iiZLxDe2s5nMJKHYezUY60ujqT
+Ljv3Ku4uAk5PgXltZnWGz152ntjopA0gbnlU4f+SgnmPoBFcvn36BcUQWQbTDqmh
+h+Y0OaXR3x/27M/qkPBov4IAfoCkWeF7i02wxwtdTLiSF7OjTDkQXtZemUzN5+w=
+-----END CERTIFICATE-----
diff --git a/testdata/file.sig b/testdata/file.sig
new file mode 100644
index 0000000000000000000000000000000000000000..1ba61f8c939c8d2616953f4ac8681f9f5988cd0c
GIT binary patch
literal 708
zcmXqLVmiRasnzDu_MMlJooPW6(?)|PrnO9rjE4LMylk8aZ61uN%q&cdtPBR+2!)J>
zO-vm?g)KmZ2C)XNhTI06Y|No7Y{E>Ap@zZ+f*=kD4_9!0ZmMo@Nn%N=p`w92NRW$1
z!ZWWVwJ0yOL?JvgB|WpGSRtUKQo*Mrg-IlFNkp-l8&CJ&nx4YHQk)05x7~k*?h2rz
zpw49kI*O%<iGg!!lb*qm@M8gu7e2ppaAveD+qdta)zR|kQ_GGWju6_iS3RtEj?1rg
z+gxO3AC%f_zvR$9_K?K_FQ$C6T*1iT$$!u=sI$GcweNhG#bo1Se$U@W|7bs-u~RuT
zU#P+L)aCq#yX-Ijxbv4q?@y!phckhfsuNNst$+A+ht(TN#?A&FrAehGYl}Ah^IBOZ
zFE&9<L+zgUob1vD12=Q7t%Wh|Dwziqrj)&ZH>2X4fms>ft>ndJ&RWZ5o8OfE)I0Q6
z-6Gz&UN@n8PH&~n8Ron1h2-iB%AcH>;*)fTRg+QP_VW6LCgwlyW$PTeS?E-7>6iaL
z`wr!rH%<%BaBj{tc){-6eZF`F`)q})$1~qD6-lRB$+bHdidb<+X(vwQV3}Su^X6(f
zPpcJEKiBT9e|SqKy31_Uw;f-4<ko4+GgXEu*XL=hf6>FLe&@{^S^gbv_r9sUnz_05
zVb_<#Cv7_lu6LcxI#s-4=G-6GXIH=4{&L>-9s1c7rOM^Mp141CdtB$ba}wiu{eSzy
zrl_1d5~eTyPr8;jtJdhvzwQ6NulgwBQD%Nu&%M{<u5A|Y`bI`wR&hz|jMq*sYZKKM
zMjjTp@bXEI;OeZ`aosaDGEOglf9yz&iu@AKoXSX^%f{~*Z+*~rF5Ehk$7`w6*%N68
hQ#Gt}UVr&ozToz@w0R5m{&x=h$?<v4+YgS@jRE2!E@}V(

literal 0
HcmV?d00001

diff --git a/testdata/key.pem b/testdata/key.pem
new file mode 100644
index 0000000..e76db4c
--- /dev/null
+++ b/testdata/key.pem
@@ -0,0 +1,52 @@
+-----BEGIN PRIVATE KEY-----
+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
+x55d2r87sh6ScDvl57EIav09Y6W/
+-----END PRIVATE KEY-----
-- 
2.26.2

