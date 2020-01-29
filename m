Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A6C14C41C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Jan 2020 01:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgA2Any (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 28 Jan 2020 19:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgA2Any (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 28 Jan 2020 19:43:54 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B6B720663;
        Wed, 29 Jan 2020 00:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580258633;
        bh=Sz/j53Dlf4MmHfKEkkCGhQTLBEmti0a764YSF89K/1Q=;
        h=From:To:Cc:Subject:Date:From;
        b=y23wHW0qmOq8PGEu1lrBgUSk6oKEaoLyUulGN26+Q6zAdCat0F2mM3V5dXWP3Q+KE
         t0AY5BXS+uB+rznVrnEU7ltxPbUHSfDqUCOYQ+LDw8Sr12HBX17mprB2kXysw4xCCS
         tPbC7UhAAXsMQXkYa5cI2Q+2nIYSXcBVMe+6xrR4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org,
        Murphy Zhou <xzhou@redhat.com>
Subject: [PATCH] generic/581: try to avoid flakiness in keys quota test
Date:   Tue, 28 Jan 2020 16:42:51 -0800
Message-Id: <20200129004251.133747-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

generic/581 passes for me, but Murphy Zhou reported that it started
failing for him.  The part that failed is the part that sets the key
quota to the fsgqa user's current number of keys plus 5, then tries to
add 6 filesystem encryption keys as the fsgqa user.  Adding the 6th key
unexpectedly succeeded.

What I think is happening is that because the kernel's keys subsystem
garbage-collects keys asynchronously, the quota may be freed up later
than expected after removing fscrypt keys.  Thus the test is flaky.

It would be nice to fix this in the kernel, but unfortunately there
doesn't seem to be an easy fix, and the keys subsystem has always worked
this way.  And it seems unlikely to cause real-world problems, as the
keys quota really just exists to prevent denial-of-service attacks.

So, for now just try to make the test more reliable by:

(1) Reduce the scope of the modified keys quota to just the part of the
    test that needs it.
(2) Before getting the current number of keys for the purpose of setting
    the quota, wait for any invalidated keys to be garbage-collected.

Tested with a kernel that has a 1 second sleep hacked into the beginning
of key_garbage_collector().  With that, this test fails before this
patch and passes afterwards.

Reported-by: Murphy Zhou <xzhou@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/581 | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/tests/generic/581 b/tests/generic/581
index 89aa03c2..bc49eadc 100755
--- a/tests/generic/581
+++ b/tests/generic/581
@@ -45,14 +45,6 @@ _require_scratch_encryption -v 2
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
-# Set the fsgqa user's key quota to their current number of keys plus 5.
-orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
-: ${orig_keys:=0}
-echo "orig_keys=$orig_keys" >> $seqres.full
-orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
-keys_to_add=5
-echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
-
 dir=$SCRATCH_MNT/dir
 
 raw_key=""
@@ -98,6 +90,24 @@ _user_do_rm_enckey $SCRATCH_MNT $keyid
 
 _scratch_cycle_mount	# Clear all keys
 
+# Wait for any invalidated keys to be garbage-collected.
+i=0
+while grep -E -q '^[0-9a-f]+ [^ ]*i[^ ]*' /proc/keys; do
+	if ((++i >= 20)); then
+		echo "Timed out waiting for invalidated keys to be GC'ed" >> $seqres.full
+		break
+	fi
+	sleep 0.5
+done
+
+# Set the user key quota to the fsgqa user's current number of keys plus 5.
+orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
+: ${orig_keys:=0}
+echo "orig_keys=$orig_keys" >> $seqres.full
+orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
+keys_to_add=5
+echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
+
 echo
 echo "# Testing user key quota"
 for i in `seq $((keys_to_add + 1))`; do
@@ -106,6 +116,9 @@ for i in `seq $((keys_to_add + 1))`; do
 	    | sed 's/ with identifier .*$//'
 done
 
+# Restore the original key quota.
+echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
+
 rm -rf $dir
 echo
 _user_do "mkdir $dir"
-- 
2.25.0.341.g760bfbb309-goog

