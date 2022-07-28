Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAEE5845AA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jul 2022 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiG1SOk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Jul 2022 14:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiG1SOj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Jul 2022 14:14:39 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAA874DDC;
        Thu, 28 Jul 2022 11:14:38 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id A2015320091E;
        Thu, 28 Jul 2022 14:14:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 28 Jul 2022 14:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1659032077; x=1659118477; bh=GeRnHWEwj8YPNofJjj/UtC8xy
        T3/G+6oG98H76JMglI=; b=iMj751QYQXiKv2mcxuYKL2r1JZKne5klzCkDErvun
        uMBo5cD6ZEU71+M7lmOxD+8uL9dI0Q8Rrjk+q9i8Hrh0Ch6rkC74Muk3xnHehFPF
        xQTSwWXsfsbsPzqeCyKVticJxiH7FU2E302eoTbdH09epqZZ/1IMvSRL5luOJt1m
        +Z2ZZExQ8QUTERgF7mqKnCKTOShLiX9+jrZQj2IPUexj+HOgaOcVoi8KnluteR9f
        mGflCfVhDxuiwGnfDt0M3O99fe73boPm5aNyzXH41nQXqrVP5j1E7OoZgiouBApr
        8XCWsvCFohvUhhdnZ4aLkwswq3hPMq3Wmr+AwoivB991w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1659032077; x=1659118477; bh=GeRnHWEwj8YPNofJjj/UtC8xyT3/G+6oG98
        H76JMglI=; b=DO/78GQmFziGcTEitEeq4ZMXpKLPPeR19HSZXw0qkVj+yq3WRi+
        00Yb5L25H3fKAPDnTW8uMGvj+C57jZU995mZcBoVTlXYNsgbjZSDLUnuCu5FPdiV
        a+L+h3zURcVdAADogKMtZExjxaCaqzGuxlCj+4615nzwcfg2TWFWBMXRwgQEgKGz
        kz0havo9fKRMHtfWwSLKN5Bw2HE0eCqjHDOxPBJQXfqpjXnAbbwPJbyl6Pxfh90i
        5SCP4Yv0Pyp6qHLWoqD6Atjh1ZI7bFTtVBgjLQUmsWGLp/lFKDsENUZCEWdyONJT
        DlRTES2h95wywsFSTQToaeVjBWxck4JZ2oA==
X-ME-Sender: <xms:DNLiYowu_tRq8aYMmAhxcrvjUuFgNzQHShTiP1EWYIuSix79012JQw>
    <xme:DNLiYsS1EadqKGF2mkwCvWnc17BczORQ2FleLMZ6nXtMubb4UL3-qacKDGGsraWOF
    lkCzZxQnz2TyXrB2T8>
X-ME-Received: <xmr:DNLiYqXU6Is_p76EoKnfVwHRMSesc5k9y23FuoDu8SGXbogs_cH22RPCXEs_6OMt4UNT6Vx3_EAN8fJwH9ZqiVcLjtt9Yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdduhedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:DdLiYmg0LiSnvuKdRFtLhm46ieCcSGB4mhTIZeg2GtnxAbgpg6rh0Q>
    <xmx:DdLiYqCE5aYdPV0lNQmyFGUCJF8u-LkW9usKhu91TVwM7cQ_BA3vLg>
    <xmx:DdLiYnLUR8lpKf0gTREGz0IOhIeFhk1iX_Itxcf8oi2cyEbgPhCdGQ>
    <xmx:DdLiYr5k4KJSD3oo7sSYEBT5ev5_qUv_1cFkxjTlkaClYHvsaNEolQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Jul 2022 14:14:36 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2] btrfs-progs: receive: add support for fs-verity
Date:   Thu, 28 Jul 2022 11:14:35 -0700
Message-Id: <e4789647b76c8b45c95256deed1cba583993b8b1.1659031931.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Process an enable_verity cmd by running the enable verity ioctl on the
file. Since enabling verity denies write access to the file, it is
important that we don't have any open write file descriptors.

This also revs the send stream format to version 3 with no format
changes besides the new commands and attributes.

Signed-off-by: Boris Burkov <boris@bur.io>
--
Changes for v2:
- remove verity.h copy, use UAPI
---
 cmds/receive-dump.c  | 10 +++++++++
 cmds/receive.c       | 51 ++++++++++++++++++++++++++++++++++++++++++++
 common/send-stream.c | 16 ++++++++++++++
 common/send-stream.h |  3 +++
 kernel-shared/send.h | 13 +++++++++--
 5 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/cmds/receive-dump.c b/cmds/receive-dump.c
index 92e0a4c9a..5d68ecbca 100644
--- a/cmds/receive-dump.c
+++ b/cmds/receive-dump.c
@@ -344,6 +344,15 @@ static int print_fileattr(const char *path, u64 attr, void *user)
 	return PRINT_DUMP(user, path, "fileattr", "fileattr=0x%llu", attr);
 }
 
+static int print_enable_verity (const char *path, u8 algorithm, u32 block_size,
+				int salt_len, char *salt,
+				int sig_len, char *sig, void *user)
+{
+	return PRINT_DUMP(user, path, "enable_verity",
+			  "algorithm=%u block_size=%u salt_len=%d sig_len=%d",
+			  algorithm, block_size, salt_len, sig_len);
+}
+
 struct btrfs_send_ops btrfs_print_send_ops = {
 	.subvol = print_subvol,
 	.snapshot = print_snapshot,
@@ -369,4 +378,5 @@ struct btrfs_send_ops btrfs_print_send_ops = {
 	.encoded_write = print_encoded_write,
 	.fallocate = print_fallocate,
 	.fileattr = print_fileattr,
+	.enable_verity = print_enable_verity,
 };
diff --git a/cmds/receive.c b/cmds/receive.c
index aec324587..c4778d6c0 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -39,6 +39,7 @@
 #include <sys/uio.h>
 #include <sys/xattr.h>
 #include <linux/fs.h>
+#include <linux/fsverity.h>
 #include <uuid/uuid.h>
 
 #include <zlib.h>
@@ -1333,6 +1334,55 @@ static int process_fileattr(const char *path, u64 attr, void *user)
 	return 0;
 }
 
+static int process_enable_verity(const char *path, u8 algorithm, u32 block_size,
+				 int salt_len, char *salt,
+				 int sig_len, char *sig, void *user)
+{
+	int ret;
+	struct btrfs_receive *rctx = user;
+	char full_path[PATH_MAX];
+	struct fsverity_enable_arg verity_args = {
+		.version = 1,
+		.hash_algorithm = algorithm,
+		.block_size = block_size,
+	};
+	if (salt_len) {
+		verity_args.salt_size = salt_len;
+		verity_args.salt_ptr = (__u64)salt;
+	}
+	if (sig_len) {
+		verity_args.sig_size = sig_len;
+		verity_args.sig_ptr = (__u64)sig;
+	}
+	int ioctl_fd;
+
+	ret = path_cat_out(full_path, rctx->full_subvol_path, path);
+	if (ret < 0) {
+		error("write: path invalid: %s", path);
+		goto out;
+	}
+
+	ioctl_fd = open(full_path, O_RDONLY);
+	if (ioctl_fd < 0) {
+		ret = -errno;
+		error("cannot open %s for verity ioctl: %m", full_path);
+		goto out;
+	}
+
+	/*
+	 * Enabling verity denies write access, so it cannot be done with an
+	 * open writeable file descriptor.
+	 */
+	close_inode_for_write(rctx);
+	ret = ioctl(ioctl_fd, FS_IOC_ENABLE_VERITY, &verity_args);
+	if (ret < 0)
+		fprintf(stderr, "Failed to enable verity on %s: %d\n", full_path, ret);
+
+	close(ioctl_fd);
+out:
+	return ret;
+}
+
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
@@ -1358,6 +1408,7 @@ static struct btrfs_send_ops send_ops = {
 	.encoded_write = process_encoded_write,
 	.fallocate = process_fallocate,
 	.fileattr = process_fileattr,
+	.enable_verity = process_enable_verity,
 };
 
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
diff --git a/common/send-stream.c b/common/send-stream.c
index 96d1aa218..1a0c0a5b0 100644
--- a/common/send-stream.c
+++ b/common/send-stream.c
@@ -353,6 +353,12 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 	char *xattr_name = NULL;
 	void *xattr_data = NULL;
 	void *data = NULL;
+	u8 verity_algorithm;
+	u32 verity_block_size;
+	int verity_salt_len;
+	void *verity_salt = NULL;
+	int verity_sig_len;
+	void *verity_sig = NULL;
 	struct timespec at;
 	struct timespec ct;
 	struct timespec mt;
@@ -537,6 +543,16 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 		TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &tmp);
 		ret = sctx->ops->update_extent(path, offset, tmp, sctx->user);
 		break;
+	case BTRFS_SEND_C_ENABLE_VERITY:
+		TLV_GET_STRING(sctx, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, &verity_algorithm);
+		TLV_GET_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, &verity_block_size);
+		TLV_GET(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, &verity_salt, &verity_salt_len);
+		TLV_GET(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, &verity_sig, &verity_sig_len);
+		ret = sctx->ops->enable_verity(path, verity_algorithm, verity_block_size,
+					       verity_salt_len, verity_salt,
+					       verity_sig_len, verity_sig, sctx->user);
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/common/send-stream.h b/common/send-stream.h
index b5973b66f..6649b55b9 100644
--- a/common/send-stream.h
+++ b/common/send-stream.h
@@ -60,6 +60,9 @@ struct btrfs_send_ops {
 	int (*fallocate)(const char *path, int mode, u64 offset, u64 len,
 			 void *user);
 	int (*fileattr)(const char *path, u64 attr, void *user);
+	int (*enable_verity)(const char *path, u8 algorithm, u32 block_size,
+			     int salt_len, char *salt,
+			     int sig_len, char *sig, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
diff --git a/kernel-shared/send.h b/kernel-shared/send.h
index 0236d9fd8..db1bec19f 100644
--- a/kernel-shared/send.h
+++ b/kernel-shared/send.h
@@ -102,8 +102,10 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_ENCODED_WRITE	= 25,
 	BTRFS_SEND_C_MAX_V2		= 25,
 
+	BTRFS_SEND_C_ENABLE_VERITY	= 26,
+	BTRFS_SEND_C_MAX_V3		= 26,
 	/* End */
-	BTRFS_SEND_C_MAX		= 25,
+	BTRFS_SEND_C_MAX		= 26,
 };
 
 /* attributes in send stream */
@@ -170,8 +172,15 @@ enum {
 	BTRFS_SEND_A_ENCRYPTION		= 31,
 	BTRFS_SEND_A_MAX_V2		= 31,
 
+	/* Version 3 */
+	BTRFS_SEND_A_VERITY_ALGORITHM	= 32,
+	BTRFS_SEND_A_VERITY_BLOCK_SIZE	= 33,
+	BTRFS_SEND_A_VERITY_SALT_DATA	= 34,
+	BTRFS_SEND_A_VERITY_SIG_DATA	= 35,
+	BTRFS_SEND_A_MAX_V3		= 35,
+
 	/* End */
-	BTRFS_SEND_A_MAX		= 31,
+	BTRFS_SEND_A_MAX		= 35,
 };
 
 #endif
-- 
2.37.1

