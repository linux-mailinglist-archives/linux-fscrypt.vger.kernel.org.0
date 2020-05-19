Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E701D8DD0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 May 2020 04:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgESCyZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 May 2020 22:54:25 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55316 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbgESCyZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 May 2020 22:54:25 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04J2rtRb003270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 22:53:56 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7EB3E420304; Mon, 18 May 2020 22:53:55 -0400 (EDT)
Date:   Mon, 18 May 2020 22:53:55 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 3/4] fscrypt: support test_dummy_encryption=v2
Message-ID: <20200519025355.GC2396055@mit.edu>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-4-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 12, 2020 at 04:32:50PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> v1 encryption policies are deprecated in favor of v2, and some new
> features (e.g. encryption+casefolding) are only being added for v2.
> 
> Therefore, the "test_dummy_encryption" mount option (which is used for
> encryption I/O testing with xfstests) needs to support v2 policies.
> 
> To do this, extend its syntax to be "test_dummy_encryption=v1" or
> "test_dummy_encryption=v2".  The existing "test_dummy_encryption" (no
> argument) also continues to be accepted, to specify the default setting
> -- currently v1, but the next patch changes it to v2.
> 
> To cleanly support both v1 and v2 while also making it easy to support
> specifying other encryption settings in the future (say, accepting
> "$contents_mode:$filenames_mode:v2"), make ext4 and f2fs maintain a
> pointer to the dummy fscrypt_context rather than using mount flags.
> 
> To avoid concurrency issues, don't allow test_dummy_encryption to be set
> or changed during a remount.  (The former restriction is new, but
> xfstests doesn't run into it, so no one should notice.)
> 
> Tested with 'gce-xfstests -c {ext4,f2fs}/encrypt -g auto'.  On ext4,
> there are two regressions, both of which are test bugs: ext4/023 and
> ext4/028 fail because they set an xattr and expect it to be stored
> inline, but the increase in size of the fscrypt_context from
> 24 to 40 bytes causes this xattr to be spilled into an external block.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good, but could you do me a favor and merge in this?

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 04bfaf63752c..6c9fc9e21c13 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -293,6 +293,7 @@ EXT4_ATTR_FEATURE(batched_discard);
 EXT4_ATTR_FEATURE(meta_bg_resize);
 #ifdef CONFIG_FS_ENCRYPTION
 EXT4_ATTR_FEATURE(encryption);
+EXT4_ATTR_FEATURE(test_dummy_encryption_v2);
 #endif
 #ifdef CONFIG_UNICODE
 EXT4_ATTR_FEATURE(casefold);
@@ -308,6 +309,7 @@ static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(meta_bg_resize),
 #ifdef CONFIG_FS_ENCRYPTION
 	ATTR_LIST(encryption),
+	ATTR_LIST(test_dummy_encryption_v2),
 #endif
 #ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),

This will make it easier to have the gce-xfstests test runner know
whether or not test_dummy_encryption=v1 / test_dummy_encryption=v2
will work, and whether test_dummy_encryption tests v1 or v2.

Thanks!

					- Ted
