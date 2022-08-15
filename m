Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A99594D1A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Aug 2022 03:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344103AbiHPBHU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Aug 2022 21:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348818AbiHPBFr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Aug 2022 21:05:47 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638461A6CF1;
        Mon, 15 Aug 2022 13:53:20 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 431B6320005D;
        Mon, 15 Aug 2022 16:53:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 16:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660596798; x=1660683198; bh=4HF4atPitOwJxsFpcbFwEfLwG
        6JNhwmv0CdXypzbmE8=; b=qPachOO9GEkwzkLhDVYmaq4nRHvU/2aLUfpalA42/
        WGeVULkU0xvq5ly0hzSImQ3zTKFNhqlMzWwkXnCr9UeB5bR3D3gBkG9I2j01DWLN
        l9TkhAKN4Ij6q4hk8+mrIQlA0RSC4ejybF2xUEoNJXelrJlOu5+2q3Al5P4SnNuJ
        agqs84X5VA+OJSGTe7RLcbl3NTXqbZ97cxZJnVurha6RHVC6MPzjXMbCLm86ZYmv
        Jam91lybxvcNQvsxpFJa3oA85t9Hf3xxh38DVyrGzWveZO3ez1AFhmAfget2UOlG
        f3woMyMuJKNNsms6kfgn+YQt7h9zdcd4ULgVh6fssyTQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660596798; x=1660683198; bh=4HF4atPitOwJxsFpcbFwEfLwG6JNhwmv0Cd
        XypzbmE8=; b=4uyznmwvJXSKGsEdaBGdjPnT3GkD7Bjkd94MGbj7CEjWphdR0Xy
        0RY0Sva05QtgSk7Xvy3cJ2KshgaqqexbgArdXJe0KJosycoJmsnVF/zaXpLVa5Mh
        T18mo5wjOsLoCpMJ6t8FxvaRhKzahhAXdv1fnOZBCLsSEuWPTj1L6pVrV/yyJBsX
        LF+E7rrxFbivhK30eD4kbxHR7mGLMUm1m8ATvXMUVZknp1xWetzfNUI9EsEYt98/
        3W4L85RpdjNkHUMV/byuJVeuFPtX5g9tEYwwBRFShsnfWL1W1vLm/ho5scpudEU/
        ti2B/6zfQsoxOeNFnVXPxn56WKIORPvjAdw==
X-ME-Sender: <xms:PrL6YislSrhXdyJOsqtAAgdm0gGdXHs6igpEOD_8RdseQRMVT-CB7g>
    <xme:PrL6YneRkOo5QYOYkv7N47hNGUiBQRYJnfVinmhWgzLmh4vkQQvJdqVLLorrKle6N
    CDWIaTTYxx-TeP66BM>
X-ME-Received: <xmr:PrL6YtwxUwWvjU8cm1cihestUWORDnwubeqodhq3DqmucEL42qJoD487Ibb5JOnYdUjJoIrJx6KG6HwHlK79A67VwVbm1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:PrL6YtNO6wag4T4i0RHovNdh21s8_YwoYIovENWvr2FgtkL6E239Dg>
    <xmx:PrL6Yi_myTtA9Q4TJdiUzk0bzxf3adzg7APHI96z2-_j3UJ4K_nugA>
    <xmx:PrL6YlXY_09-SnoUb2UBta3yHhdhcXTNr_bX6JxpuSyCdhGqbbl-GA>
    <xmx:PrL6YolBIJep7REj46N7cv8tce_fhlaysTPQTTqXEFxidQoD3o0yQQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 16:53:18 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3] btrfs-progs: receive: add support for fs-verity
Date:   Mon, 15 Aug 2022 13:54:42 -0700
Message-Id: <3cf3573328789fcacb968f7707dc6839e44043f9.1660595824.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Note: the build is conditional on the header linux/fsverity.h

Signed-off-by: Boris Burkov <boris@bur.io>
--
Changes for v3:
- make build conditional on presence of header file
- read errno for errors in fsverity ioctl
- correct uintptr_t casting for salt/sig pointers
Changes for v2:
- remove verity.h copy, use UAPI
---
 cmds/receive-dump.c  | 10 +++++++
 cmds/receive.c       | 65 ++++++++++++++++++++++++++++++++++++++++++++
 common/send-stream.c | 16 +++++++++++
 common/send-stream.h |  3 ++
 configure.ac         |  1 +
 kernel-shared/send.h | 13 +++++++--
 6 files changed, 106 insertions(+), 2 deletions(-)

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
index aec324587..02caa0b56 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -39,6 +39,9 @@
 #include <sys/uio.h>
 #include <sys/xattr.h>
 #include <linux/fs.h>
+#if HAVE_LINUX_FSVERITY_H
+#include <linux/fsverity.h>
+#endif
 #include <uuid/uuid.h>
 
 #include <zlib.h>
@@ -1333,6 +1336,67 @@ static int process_fileattr(const char *path, u64 attr, void *user)
 	return 0;
 }
 
+#if HAVE_LINUX_FSVERITY_H
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
+		verity_args.salt_ptr = (__u64)(uintptr_t)salt;
+	}
+	if (sig_len) {
+		verity_args.sig_size = sig_len;
+		verity_args.sig_ptr = (__u64)(uintptr_t)sig;
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
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to enable verity on %s: %d\n", full_path, ret);
+	}
+
+	close(ioctl_fd);
+out:
+	return ret;
+}
+#else
+static int process_enable_verity(const char *path, u8 algorithm, u32 block_size,
+				 int salt_len, char *salt,
+				 int sig_len, char *sig, void *user)
+{
+	error("fs-verity for stream not compiled in");
+	return -EOPNOTSUPP;
+}
+#endif
+
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
@@ -1358,6 +1422,7 @@ static struct btrfs_send_ops send_ops = {
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
diff --git a/configure.ac b/configure.ac
index f6b341813..6fd1a93bb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -66,6 +66,7 @@ AX_GCC_BUILTIN([__builtin_mul_overflow])
 
 AC_CHECK_HEADERS([linux/perf_event.h])
 AC_CHECK_HEADERS([linux/hw_breakpoint.h])
+AC_CHECK_HEADERS([linux/fsverity.h])
 
 m4_ifndef([PKG_PROG_PKG_CONFIG],
   [m4_fatal([Could not locate the pkg-config autoconf
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

