Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E812D39A6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Dec 2020 05:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgLIEeo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 23:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgLIEeo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 23:34:44 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [xfstests-bld PATCH] android-xfstests: create /dev/fd on the Android device
Date:   Tue,  8 Dec 2020 20:33:05 -0800
Message-Id: <20201209043305.77917-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In order for bash process substitution (the syntax like "<(list)" or
">(list)") to work, /dev/fd has to be a symlink to /proc/self/fd.
/dev/fd doesn't exist on Android, so create it if it's missing.

This fixes xfstest generic/576.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kvm-xfstests/android-xfstests | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kvm-xfstests/android-xfstests b/kvm-xfstests/android-xfstests
index a8f9be9..7741162 100755
--- a/kvm-xfstests/android-xfstests
+++ b/kvm-xfstests/android-xfstests
@@ -244,6 +244,11 @@ if ! cut -d' ' -f2 /proc/mounts 2>/dev/null | grep -q '^$CHROOT_DIR/results$'; t
     mount --bind $RESULTS_DIR $CHROOT_DIR/results
 fi
 
+# /dev/fd needs to exist in order for bash process substitution to work.
+if [ ! -e /dev/fd ]; then
+	ln -s /proc/self/fd /dev/fd
+fi
+
 # Android puts loopback device nodes in /dev/block/ instead of /dev/.
 # But losetup can only find them in /dev/, so create them there too.
 for i in \`seq 0 7\`; do
-- 
2.29.2

