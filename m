Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DEB3CCA58
	for <lists+linux-fscrypt@lfdr.de>; Sun, 18 Jul 2021 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhGRTLb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Jul 2021 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGRTLa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Jul 2021 15:11:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE9C611AB;
        Sun, 18 Jul 2021 19:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626635312;
        bh=KIAcM2dZ31TZo28JHSbva0YrxoL/NJhQqVcdHSsyQBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K64D66IbJSWUdIWNgna9uwb3lts8+y+q27Ov1MCq8mRV95GdhnsKyliDZMJC914wH
         /SLKfl406bCB+EpU41zMR20v6UWSj2t1999wIF8HxlaZQ2hGdwugB0W1nL+QIuEK4U
         U5h/FCBw8lbc3sqRb+WzHUJu76xFysuEj4zLwqMauZPjkHlACG3d1/4UFCc1CWJeKI
         qRxuiEoyiZ4M7s1sODizm51H/OA7M1cqMekymTsLpPNZabn1siM99WypAimEmJrUpg
         NJ7o5csysF6mqnaVhcwh6poSCAz9wD1f5XezHaghB4NgnhW6xZpV/FZEWvsJYq614Z
         87wgAIOYKJ/Cg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/3] common/encrypt: add helper function for filtering no-key names
Date:   Sun, 18 Jul 2021 14:06:57 -0500
Message-Id: <20210718190658.61621-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210718190658.61621-1-ebiggers@kernel.org>
References: <20210718190658.61621-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a helper function _filter_nokey_filenames() which replaces no-key
filenames with "NOKEY_NAME".  Use it in generic/419 and generic/429.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt        | 17 +++++++++++++++++
 tests/generic/419     |  2 +-
 tests/generic/419.out |  2 +-
 tests/generic/429     | 10 +++-------
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index c4cc2d83..766a6d81 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -920,3 +920,20 @@ _verify_ciphertext_for_encryption_policy()
 		"$crypt_util_contents_args" \
 		"$crypt_util_filename_args"
 }
+
+# Replace no-key filenames in the given directory with "NOKEY_NAME".
+#
+# No-key filenames are the filenames that the filesystem shows when userspace
+# lists an encrypted directory without the directory's encryption key being
+# present.  These will differ on every run of the test, even when using the same
+# encryption key, hence the need for this filtering in some cases.
+#
+# Note, this may replace "regular" names too, as technically we can only tell
+# whether a name is definitely a regular name, or either a regular or no-key
+# name.  A directory will only contain one type of name at a time, though.
+_filter_nokey_filenames()
+{
+	local dir=$1
+
+	sed "s|${dir}${dir:+/}[A-Za-z0-9+,_]\+|${dir}${dir:+/}NOKEY_NAME|g"
+}
diff --git a/tests/generic/419 b/tests/generic/419
index 61f9d605..6be7865c 100755
--- a/tests/generic/419
+++ b/tests/generic/419
@@ -41,7 +41,7 @@ _scratch_cycle_mount
 # in a way that does not assume any particular filenames.
 efile1=$(find $SCRATCH_MNT/edir -maxdepth 1 -type f | head -1)
 efile2=$(find $SCRATCH_MNT/edir -maxdepth 1 -type f | tail -1)
-mv $efile1 $efile2 |& _filter_scratch | sed 's|edir/[a-zA-Z0-9+,_]\+|edir/FILENAME|g'
+mv $efile1 $efile2 |& _filter_scratch | _filter_nokey_filenames edir
 $here/src/renameat2 -x $efile1 $efile2
 
 # success, all done
diff --git a/tests/generic/419.out b/tests/generic/419.out
index 1bba10fd..67bb7fb1 100644
--- a/tests/generic/419.out
+++ b/tests/generic/419.out
@@ -1,3 +1,3 @@
 QA output created by 419
-mv: cannot move 'SCRATCH_MNT/edir/FILENAME' to 'SCRATCH_MNT/edir/FILENAME': Required key not available
+mv: cannot move 'SCRATCH_MNT/edir/NOKEY_NAME' to 'SCRATCH_MNT/edir/NOKEY_NAME': Required key not available
 Required key not available
diff --git a/tests/generic/429 b/tests/generic/429
index ba2281c9..558e93ca 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -52,18 +52,13 @@ _set_encpolicy $SCRATCH_MNT/edir $keydesc
 echo contents_@@@ > $SCRATCH_MNT/edir/@@@ # not valid base64
 echo contents_abcd > $SCRATCH_MNT/edir/abcd # valid base64
 
-filter_nokey_filenames()
-{
-	_filter_scratch | sed 's|edir/[a-zA-Z0-9+,_]\+|edir/NOKEY_NAME|g'
-}
-
 show_file_contents()
 {
 	echo "--- Contents of files using plaintext names:"
 	cat $SCRATCH_MNT/edir/@@@ |& _filter_scratch
 	cat $SCRATCH_MNT/edir/abcd |& _filter_scratch
 	echo "--- Contents of files using no-key names:"
-	cat ${nokey_names[@]} |& filter_nokey_filenames
+	cat ${nokey_names[@]} |& _filter_scratch | _filter_nokey_filenames edir
 }
 
 show_directory_with_key()
@@ -83,7 +78,8 @@ _unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
 echo "--- Directory listing:"
 nokey_names=( $(find $SCRATCH_MNT/edir -mindepth 1 | sort) )
-printf '%s\n' "${nokey_names[@]}" | filter_nokey_filenames
+printf '%s\n' "${nokey_names[@]}" | \
+	_filter_scratch | _filter_nokey_filenames edir
 show_file_contents
 
 # Without remounting or dropping caches, add the encryption key and view the
-- 
2.32.0

