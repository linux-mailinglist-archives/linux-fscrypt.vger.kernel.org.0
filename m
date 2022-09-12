Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0E5B5284
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Sep 2022 03:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiILBec (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Sep 2022 21:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiILBeb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Sep 2022 21:34:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86DE334;
        Sun, 11 Sep 2022 18:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE576113E;
        Mon, 12 Sep 2022 01:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77745C433D6;
        Mon, 12 Sep 2022 01:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662946467;
        bh=UbLiyHNqxzI4SCfHnqGRgqZCSXX7SnKZwlD05U/S+u4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F++hWAqh2jrf8Z9fPqfYOt7L98S3UQPlt9gMy4qhFw3WzoM8cjSrahLSp37sFkX8J
         I9u78QpZHJprCZ0kgonIdCt3JfnjJiliOqdnUr+P5a262RLYImbZXtiaE3DjLAk2Z9
         1E4EFgwqSHyCzPlldt50Jqq8QVNE4cte+iBcqQ+3H3U70/rQVsgYcxEGxwXZrYKGF3
         9AS9URitniXU1cZlI6bB5kxS8hj1xisqPStnEQBHgnlTLAQSfyG9utHhD+cupbkhdH
         fxehpMusYvHb1SSVRq5itNJidvpPFvChnVBrjJnbRrrbsd1+SmB7Wy6KOw/LSplPO+
         qRqXHQiJ12eCA==
Date:   Sun, 11 Sep 2022 20:34:21 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 05/20] fscrypt: add extent-based encryption
Message-ID: <Yx6MnaUqUTdjCmX+@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <48d09d4905d0c6e5e72d37535eb852487f1bd9cb.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d09d4905d0c6e5e72d37535eb852487f1bd9cb.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:20PM -0400, Sweet Tea Dorminy wrote:
> Some filesystems need to encrypt data based on extents, rather than on
> inodes, due to features incompatible with inode-based encryption. For
> instance, btrfs can have multiple inodes referencing a single block of
> data, and moves logical data blocks to different physical locations on
> disk in the background; these two features mean inode or
> physical-location-based policies will not work for btrfs.
> 
> This change introduces fscrypt_extent_context objects, in analogy to
> existing context objects based on inodes. For a filesystem which uses
> extents, a new hook provides a new fscrypt_extent_context. During file
> content encryption/decryption, the existing fscrypt_context object
> provides key information, while the new fscrypt_extent_context provides
> IV information. For filename encryption, the existing IV generation
> methods are still used, since filenames are not stored in extents.
> 
> As individually keyed inodes prevent sharing of extents, such policies
> are forbidden for filesystems with extent-based encryption.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/crypto.c          | 15 +++++++-
>  fs/crypto/fscrypt_private.h | 26 ++++++++++++-
>  fs/crypto/inline_crypt.c    | 29 +++++++++++---
>  fs/crypto/policy.c          | 77 +++++++++++++++++++++++++++++++++++++
>  include/linux/fscrypt.h     | 41 ++++++++++++++++++++
>  5 files changed, 178 insertions(+), 10 deletions(-)
> 

I'm on vacation at the moment, but I've been thinking about this patchset and
I'll leave some quick high-level feedback.

I think that you've sort of ended up with something reasonable in this patch,
though maybe not for exactly the reasons you thought, and it still needs to be
tweaked a bit.

Thinking abstractly, an encryption policy indicates that a set of files is
encrypted with a particular key.  That set of files contains a set of objects
containing "file contents", each containing a sequence of file contents blocks.
File contents encryption is the encryption that is applied to these objects.

With other filesystems, the "file contents objects" are inodes.  With btrfs, the
"file contents objects" are extents.

I think it's fair to say that this is just a difference in the filesystems, and
it doesn't need to be explicitly indicated in the encryption policy.

What *is* super important, though, is to keep the cryptography consistent.

Consider the existing default setting, which derives a per-inode key from the
master key and a per-inode nonce, and sets the IV to the offset into the inode.
There is a natural mapping of that to extent-based encryption: derive a
per-extent key from the master key and a per-extent nonce, and set the IV to the
offset into the extent.

But you haven't actually implemented that.  I assume that you've discarded
per-extent keys as infeasible?

If that's the case, then the alternative is to do file contents encryption with
a per-mode key, using an IV generation method that makes the IVs identify both
the file contents object *and* the offset into it, rather than just the latter.

The existing methods for that are DIRECT_KEY, IV_INO_LBLK_32, and
IV_INO_LBLK_64.  DIRECT_KEY uses a 16-byte nonce to identify the file contents
object.  IV_INO_LBLK_32 and IV_INO_LBLK_64 use a filesystem-assigned ID;
currently this ID is inode number, but if they were to be applied to
extent-based encryption, it would be an "extent number" instead.

So if you do want to implement the DIRECT_KEY method, the natural thing to do
would be to store a 16-byte nonce along with each extent, and use the DIRECT_KEY
IV generation method as-is.  It seems that you've done it a bit differently; you
store a 32-byte nonce and generate the IV as 'nonce + lblk_num', instead of
'nonce || lblk_num'.  I think that's a mistake -- it should be exactly the same.

If the issue is that the 'nonce || lblk_num' method doesn't allow for AES-XTS
support, we could extend DIRECT_KEY to do 'nonce + lblk_num' *if* the algorithm
has a 16-byte IV size and thus has to tolerate some chance of IV reuse.  Note
that this change would be unrelated to extent-based encryption, and could be
applied regardless of it.

Side note: please don't use the phrase "file-based encryption" to distinguish
from "extent-based encryption", as "file-based encryption" is already in use to
distinguish from block-device based encryption.  (See e.g. all the Android
documentation that refers to file-based encryption.)  Maybe use "inode-based
encryption", or "inode-based file contents encryption" to be extra clear.

- Eric
