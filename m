Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8107C9828
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJOGZ5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOGZ5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:25:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348DFC5;
        Sat, 14 Oct 2023 23:25:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C194C433C8;
        Sun, 15 Oct 2023 06:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697351155;
        bh=cuo3f/IT7XrTEbzjCobugOZLzZVPhubLNEkRqYj/j0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsu0R9CKxiOCTMnu2BT8iShZScaxRWAbqK0YNgou4xc61SKIZMqvFzpo9kmkaZ7n/
         UqnXk9gCjbhCR4HEWfp+BV+lp3uDt8UO3XjKPPI+jWoZ3SPGhuSrjxejpCXp5Uv9B8
         p8c6Q1nL/sWdpqfb2PANctYYNEs6jURuRBeA+ICjEeCTGy201k+UtOSJ9c78p3zhWK
         yF7SOgqi7od7WZnyIDzLcLsCTzyQMsrN6q6gEsajrhmaXs447rz2Pwq9912SoZ/g6o
         24uEH69cp+4IBf23WE9BSlcM4mHjWYvdV4XbopZF423IeaDJj92vPDCjhfwLBfsDcA
         aD/hxQAp0Nw7Q==
Date:   Sat, 14 Oct 2023 23:25:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 02/36] fscrypt: don't wipe mk secret until the last
 active user is gone
Message-ID: <20231015062553.GB10525@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <e5cce8880fd1072bd08988ddd8fb2d619445bda3.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5cce8880fd1072bd08988ddd8fb2d619445bda3.1696970227.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:40:17PM -0400, Josef Bacik wrote:
> Previously we were wiping the master key secret when we do
> FS_IOC_REMOVE_ENCRYPTION_KEY, and then using the fact that it was
> cleared as the mechanism from keeping new users from being setup.  This
> works with inode based encryption, as the per-inode key is derived at
> setup time, so the secret disappearing doesn't affect any currently open
> files from being able to continue working.
> 
> However for extent based encryption we do our key derivation at page
> writeout and readpage time, which means we need the master key secret to
> be available while we still have our file open.
> 
> Since the master key lifetime is controlled by a flag, move the clearing
> of the secret to the mk_active_users cleanup stage.  This counter
> represents the actively open files that still exist on the file system,
> and thus should still be able to operate normally.  Once the last user
> is closed we can clear the secret.  Until then no new users are allowed,
> and this allows currently open files to continue to operate until
> they're closed.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/crypto/keyring.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index e0e311ed6b88..31ea81d97075 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -116,6 +116,7 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
>  	memzero_explicit(&mk->mk_ino_hash_key,
>  			 sizeof(mk->mk_ino_hash_key));
>  	mk->mk_ino_hash_key_initialized = false;
> +	wipe_master_key_secret(&mk->mk_secret);
>  
>  	/* Drop the structural ref associated with the active refs. */
>  	fscrypt_put_master_key(mk);
> @@ -245,7 +246,6 @@ void fscrypt_destroy_keyring(struct super_block *sb)
>  			WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 1);
>  			WARN_ON_ONCE(refcount_read(&mk->mk_struct_refs) != 1);
>  			WARN_ON_ONCE(!is_master_key_secret_present(mk));
> -			wipe_master_key_secret(&mk->mk_secret);
>  			set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags);
>  			fscrypt_put_master_key_activeref(sb, mk);
>  		}
> @@ -1064,7 +1064,6 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
>  	/* No user claims remaining.  Go ahead and wipe the secret. */
>  	err = -ENOKEY;
>  	if (!test_and_set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags)) {
> -		wipe_master_key_secret(&mk->mk_secret);
>  		fscrypt_put_master_key_activeref(sb, mk);
>  		err = 0;
>  	}
> -- 
> 2.41.0
> 

I think we should do this only on filesystems that use extent-based encryption.
Yes, wiping the key in the "incompletely removed" state is not essential, for
the reasons we've discussed before, but we might as well do the best we can do
on each filesystem.

- Eric
