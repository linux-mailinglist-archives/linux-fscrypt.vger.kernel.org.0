Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A183C39AB33
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jun 2021 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCUBw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 16:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhFCUBv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 16:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4025C613FA;
        Thu,  3 Jun 2021 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750406;
        bh=RPXQsS0xe5Z79qZCpzQ2I6JvPX2Lx1zo5fmiEDbzLK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgAqVWuCnFAFlIy0Ck+XJWKFL0YslRHhNDb9Q3Wm9q9zubCCvWv8gW9MnQNthmQIY
         5FZr5+naVIgFq8czccVrnd2N0EnGekMOnffuZTXFvCGZFwszaspmiXEBJJW+ZUElXy
         EciUNvZeIlola8rf7cXTMa8MRps3QXCbMB/XVwhR2dEph02h/tgA866Cdbutb6miu/
         3G7O3TqkZzsbEPcL5M45f6EjAMfzRRmsuHetWjhaIDvONmm1bdDd53WZbSJuizRxyL
         jV57CnOiGrdstjqOmB3SplQXEXUYt+F2B+klSXFwSvyMy/tvboAzV+6fV1HPpqyVU7
         UUti6xKfTc/+Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH 3/4] programs/utils: add full_pwrite() and preallocate_file()
Date:   Thu,  3 Jun 2021 12:58:11 -0700
Message-Id: <20210603195812.50838-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
References: <20210603195812.50838-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

These helper functions will be used by the implementation of the
--out-merkle-tree option for 'fsverity digest' and 'fsverity sign'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/utils.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
 programs/utils.h |  3 +++
 2 files changed, 62 insertions(+)

diff --git a/programs/utils.c b/programs/utils.c
index ce19b57..116eb95 100644
--- a/programs/utils.c
+++ b/programs/utils.c
@@ -13,10 +13,14 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <inttypes.h>
 #include <limits.h>
 #include <stdarg.h>
 #include <sys/stat.h>
 #include <unistd.h>
+#ifdef _WIN32
+#  include <windows.h>
+#endif
 
 /* ========== Memory allocation ========== */
 
@@ -126,6 +130,26 @@ bool get_file_size(struct filedes *file, u64 *size_ret)
 	return true;
 }
 
+bool preallocate_file(struct filedes *file, u64 size)
+{
+	int res;
+
+	if (size == 0)
+		return true;
+#ifdef _WIN32
+	/* Not exactly the same as posix_fallocate(), but good enough... */
+	res = _chsize_s(file->fd, size);
+#else
+	res = posix_fallocate(file->fd, 0, size);
+#endif
+	if (res != 0) {
+		error_msg_errno("preallocating %" PRIu64 "-byte file '%s'",
+				size, file->name);
+		return false;
+	}
+	return true;
+}
+
 bool full_read(struct filedes *file, void *buf, size_t count)
 {
 	while (count) {
@@ -160,6 +184,41 @@ bool full_write(struct filedes *file, const void *buf, size_t count)
 	return true;
 }
 
+static int raw_pwrite(int fd, const void *buf, int count, u64 offset)
+{
+#ifdef _WIN32
+	HANDLE h = (HANDLE)_get_osfhandle(fd);
+	OVERLAPPED pos = { .Offset = offset, .OffsetHigh = offset >> 32 };
+	DWORD written = 0;
+
+	/* Not exactly the same as pwrite(), but good enough... */
+	if (!WriteFile(h, buf, count, &written, &pos)) {
+		errno = EIO;
+		return -1;
+	}
+	return written;
+#else
+	return pwrite(fd, buf, count, offset);
+#endif
+}
+
+bool full_pwrite(struct filedes *file, const void *buf, size_t count,
+		 u64 offset)
+{
+	while (count) {
+		int n = raw_pwrite(file->fd, buf, min(count, INT_MAX), offset);
+
+		if (n < 0) {
+			error_msg_errno("writing to '%s'", file->name);
+			return false;
+		}
+		buf += n;
+		count -= n;
+		offset += n;
+	}
+	return true;
+}
+
 bool filedes_close(struct filedes *file)
 {
 	int res;
diff --git a/programs/utils.h b/programs/utils.h
index ab5005f..9a5c97a 100644
--- a/programs/utils.h
+++ b/programs/utils.h
@@ -40,8 +40,11 @@ struct filedes {
 
 bool open_file(struct filedes *file, const char *filename, int flags, int mode);
 bool get_file_size(struct filedes *file, u64 *size_ret);
+bool preallocate_file(struct filedes *file, u64 size);
 bool full_read(struct filedes *file, void *buf, size_t count);
 bool full_write(struct filedes *file, const void *buf, size_t count);
+bool full_pwrite(struct filedes *file, const void *buf, size_t count,
+		 u64 offset);
 bool filedes_close(struct filedes *file);
 int read_callback(void *file, void *buf, size_t count);
 
-- 
2.31.1

