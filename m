Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA3048B4E3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbiAKSED (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:03 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4389 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345158AbiAKSDv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:51 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJPq0CrVz67cQc;
        Wed, 12 Jan 2022 02:00:15 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:47 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 01/14] mpi: Introduce mpi_key_length()
Date:   Tue, 11 Jan 2022 19:03:05 +0100
Message-ID: <20220111180318.591029-2-roberto.sassu@huawei.com>
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

Introduce the new function to get the number of bits and bytes from an MPI.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/mpi.h |  2 ++
 lib/mpi/mpicoder.c  | 33 ++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index eb0d1c1db208..a7dd4c9d8120 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -90,6 +90,8 @@ enum gcry_mpi_format {
 };
 
 MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes);
+int mpi_key_length(const void *xbuffer, unsigned int ret_nread,
+		   unsigned int *nbits_arg, unsigned int *nbytes_arg);
 MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
 int mpi_fromstr(MPI val, const char *str);
 MPI mpi_scanval(const char *string);
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 39c4c6731094..cd10ae9968b7 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -79,22 +79,41 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 }
 EXPORT_SYMBOL_GPL(mpi_read_raw_data);
 
-MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
+int mpi_key_length(const void *xbuffer, unsigned int ret_nread,
+		   unsigned int *nbits_arg, unsigned int *nbytes_arg)
 {
 	const uint8_t *buffer = xbuffer;
-	unsigned int nbits, nbytes;
-	MPI val;
+	unsigned int nbits;
 
-	if (*ret_nread < 2)
-		return ERR_PTR(-EINVAL);
+	if (ret_nread < 2)
+		return -EINVAL;
 	nbits = buffer[0] << 8 | buffer[1];
 
 	if (nbits > MAX_EXTERN_MPI_BITS) {
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
-	nbytes = DIV_ROUND_UP(nbits, 8);
+	if (nbits_arg)
+		*nbits_arg = nbits;
+	if (nbytes_arg)
+		*nbytes_arg = DIV_ROUND_UP(nbits, 8);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_key_length);
+
+MPI mpi_read_from_buffer(const void *xbuffer, unsigned int *ret_nread)
+{
+	const uint8_t *buffer = xbuffer;
+	unsigned int nbytes;
+	MPI val;
+	int ret;
+
+	ret = mpi_key_length(xbuffer, *ret_nread, NULL, &nbytes);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
 	if (nbytes + 2 > *ret_nread) {
 		pr_info("MPI: mpi larger than buffer nbytes=%u ret_nread=%u\n",
 				nbytes, *ret_nread);
-- 
2.32.0

