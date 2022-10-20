Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3838D606C3F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 01:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJTX4i (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 19:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJTX4h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 19:56:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A23522C837;
        Thu, 20 Oct 2022 16:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EFDEB8093B;
        Thu, 20 Oct 2022 23:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF03C433C1;
        Thu, 20 Oct 2022 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666310193;
        bh=xUVIDegHVP/L0dd/0VAIByUNRKj+qzv5ladDjTMQd8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjzZR9ePsV2igOSkwpElRAyGdJB24j/CnriGXofi9e0v7dJrIngvmdOJ/6zGAotz8
         VTAuJ91BntPZ/2Ps6+TA7zVrAMogHbZn+3ajwfdb4t/WcweH0mUDAxgQStoVktKLtO
         aQhYVdLNO8vl0nR0jyvQbGo87OSAGe+XOmDFjYAP7K8rlJmbRCRpHbX7q/Z8Z/Mq02
         wE9663MpOiLce9J28y/LAq2hkIm8dU2EIQKvRvW6XWgGuGMk4YR5I0/3rKln+ol+kk
         pQos7Z59LefYco3gGK+HJp0tYaKfppNkZuhl8lBX+cRYuJ1vXc3860KoXWC/kWdVZf
         Bb41gleh/nqqA==
Date:   Thu, 20 Oct 2022 16:56:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 04/22] fscrypt: add extent-based encryption
Message-ID: <Y1HgL+2e/r6H0D45@sol.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
 <Y1HBkva6fzSMpm+P@sol.localdomain>
 <43955182-7158-0ce9-aeff-7dfa51559624@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43955182-7158-0ce9-aeff-7dfa51559624@dorminy.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 06:55:04PM -0400, Sweet Tea Dorminy wrote:
> 
> 
> On 10/20/22 17:45, Eric Biggers wrote:
> > On Thu, Oct 20, 2022 at 12:58:23PM -0400, Sweet Tea Dorminy wrote:
> > > Some filesystems need to encrypt data based on extents, rather than on
> > > inodes, due to features incompatible with inode-based encryption. For
> > > instance, btrfs can have multiple inodes referencing a single block of
> > > data, and moves logical data blocks to different physical locations on
> > > disk in the background; these two features mean traditional inode-based
> > > file contents encryption will not work for btrfs.
> > > 
> > > This change introduces fscrypt_extent_context objects, in analogy to
> > > existing context objects based on inodes. For a filesystem which opts to
> > > use extent-based encryption, a new hook provides a new
> > > fscrypt_extent_context, generated in close analogy to the IVs generated
> > > with existing policies. During file content encryption/decryption, the
> > > existing fscrypt_context object provides key information, while the new
> > > fscrypt_extent_context provides IV information. For filename encryption,
> > > the existing IV generation methods are still used, since filenames are
> > > not stored in extents.
> > > 
> > > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > > ---
> > >   fs/crypto/crypto.c          | 20 ++++++++--
> > >   fs/crypto/fscrypt_private.h | 25 +++++++++++-
> > >   fs/crypto/inline_crypt.c    | 28 ++++++++++---
> > >   fs/crypto/policy.c          | 79 +++++++++++++++++++++++++++++++++++++
> > >   include/linux/fscrypt.h     | 47 ++++++++++++++++++++++
> > >   5 files changed, 189 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > > index 7fe5979fbea2..08b495dc5c0c 100644
> > > --- a/fs/crypto/crypto.c
> > > +++ b/fs/crypto/crypto.c
> > > @@ -81,8 +81,22 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
> > >   			 const struct fscrypt_info *ci)
> > >   {
> > >   	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
> > > +	struct inode *inode = ci->ci_inode;
> > > +	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
> > > -	memset(iv, 0, ci->ci_mode->ivsize);
> > > +	memset(iv, 0, sizeof(*iv));
> > > +	if (s_cop->get_extent_context && lblk_num != U64_MAX) {
> > > +		size_t extent_offset;
> > > +		union fscrypt_extent_context ctx;
> > > +		int ret;
> > > +
> > > +		ret = fscrypt_get_extent_context(inode, lblk_num, &ctx,
> > > +						 &extent_offset, NULL);
> > > +		WARN_ON_ONCE(ret);
> > > +		memcpy(iv->raw, ctx.v1.iv.raw, sizeof(*iv));
> > > +		iv->lblk_num += cpu_to_le64(extent_offset);
> > > +		return;
> > > +	}
> > 
> > Please read through my review comment
> > https://lore.kernel.org/linux-fscrypt/Yx6MnaUqUTdjCmX+@quark/ again, as it
> > doesn't seem that you've addressed it.
> > 
> > - Eric
> 
> I probably didn't understand it correctly. I think there were three points
> in it:
> 
> 1) reconsider per-extent keys
> 2) make IV generation work for non-directkey policies as similarly as
> possible to how they work in inode-based filesystems
> 3) never use 'file-based' except in contrast to dm-crypt and other
> block-layer encryption.
> 
> For point 2, I changed the initial extent context generation to match up
> with fscrypt_generate_iv() (and probably didn't call that out enough in the
> description). (Looking at it again, I could literally call
> fscrypt_generate_iv() to generate the initial extent context; I didn't
> realize that before).
> 
> Then adding lblk_num to the existing lblk_num in the iv from the start of
> the extent should be the same as the iv->lblk_num setting in the inode-based
> case: for lblk 12, for instance, the same IV should result from inode-based
> with lblk 12, as with extent-based with an initial lblk_num of 9 and an
> extent_offset of 3. For shared extents, they'll be different, but for
> singly-referenced extents, the IVs should be exactly the same in theory.
> 
> I'm not sure whether I misunderstood the points or didn't address them
> fully, I apologize. Would you be up for elaborating where I missed, either
> by email or by videochat whenever works for you?

It seems you misunderstood point (2).  See what I said below:

	So if you do want to implement the DIRECT_KEY method, the natural thing
	to do would be to store a 16-byte nonce along with each extent, and use
	the DIRECT_KEY IV generation method as-is.  It seems that you've done it
	a bit differently; you store a 32-byte nonce and generate the IV as
	'nonce + lblk_num', instead of 'nonce || lblk_num'.  I think that's a
	mistake -- it should be exactly the same.

	If the issue is that the 'nonce || lblk_num' method doesn't allow for
	AES-XTS support, we could extend DIRECT_KEY to do 'nonce + lblk_num'
	*if* the algorithm has a 16-byte IV size and thus has to tolerate some
	chance of IV reuse.  Note that this change would be unrelated to
	extent-based encryption, and could be applied regardless of it.

So:

1.) Provided that you've decided against per-extent keys, and are not trying to
    support UFS and eMMC inline encryption hardware, then you should *only*
    support DIRECT_KEY -- not other settings that don't make sense.

2.) There should be a preparatory patch that makes DIRECT_KEY be allowed when
    the IV length is 16 bytes, using the method 'nonce + lblk_num' -- assuming
    that you need AES-XTS support and aren't planning on supporting Adiantum or
    AES-HCTR2 only.  (The small chance for IV reuse that it results in is not
    ideal, but it's probably tolerable.  Maybe the nonce should also be hashed
    with a secret key, like what IV_INO_LBLK_32 does with the inode number; I'll
    have to think about it.)  If you plan to just support AES-HCTR2 instead of
    AES-XTS, then you'd need a patch to allow AES-HCTR2 for contents encryption,
    as currently it is only allowed for filenames.

3.) Each extent context should contain a 16-byte random nonce, that is newly
    generated just for that extent -- not copied from anywhere.

4.) IVs should be generated using the DIRECT_KEY method.  That is,
    'nonce || lblk_num' if the IV length allows it, otherwise 'nonce + lblk_num'
    as mentioned in (2).  For inode-based encryption, nonce means the inode's
    nonce, and lblk_num means the index of the block in the inode.  For
    extent-based encryption, nonce will mean the extent's nonce, and lblk_num
    will mean the index of the block in the extent.

- Eric
