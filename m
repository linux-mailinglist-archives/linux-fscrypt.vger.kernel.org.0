Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C3B523C32
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 20:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbiEKSDh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 May 2022 14:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEKSDg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 May 2022 14:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF97EA3C;
        Wed, 11 May 2022 11:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E96B61DE9;
        Wed, 11 May 2022 18:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92029C34113;
        Wed, 11 May 2022 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652292214;
        bh=2U0jTmIfaPDRASsGiVi/9tx1zQUG8XISqj4Eqy8cSfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQSphQiQ7SqP2mcfeck+Gm2sNcIvv7mu4RwTZOQMar7+BSJRbc0dZ6wqNxQGmiNSL
         TCChQBZm7XZidPrNYwH6poMS1CI/RzANnTic9ViQlOStMLBbzafZAdU/jYYSz1zlFG
         k6ESFISDuR/M4x23DoweT5vTaXVs8rWVo1ze5rjEwxImjlwexEGNkptituO75bzh1s
         /QJFy93be2dIyeOVuM4cT8H/AW9bvBMoIH2HqgNPgfN7qL0QIXrkDoTxJDw+t9HW09
         5trxJ4QrXLj6cfDga2B6YlhMf5tnIKeJdUgtbZ3wnb94iP754fB3fS6aSmUGyBKsLO
         bhd+FJk3Fxesg==
Date:   Wed, 11 May 2022 18:03:33 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v2 5/7] ext4: fix up test_dummy_encryption
 handling for new mount API
Message-ID: <Ynv6dRdf3vZH7v2W@gmail.com>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-6-ebiggers@kernel.org>
 <Ynmma+tkA2myRvz6@sol.localdomain>
 <20220511175433.inua5nj6l7qtlywq@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511175433.inua5nj6l7qtlywq@riteshh-domain>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 11, 2022 at 11:24:33PM +0530, Ritesh Harjani wrote:
> On 22/05/09 04:40PM, Eric Biggers wrote:
> > A couple corrections I'll include in the next version:
> 
> Need few clarifications. Could you please help explain what am I missing here?
> 
> >
> > On Sat, Apr 30, 2022 at 10:08:55PM -0700, Eric Biggers wrote:
> > > +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> > > +		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
> > > +						 &ctx->dummy_enc_policy))
> > > +			return 0;
> > >  		ext4_msg(NULL, KERN_WARNING,
> > > -			 "Can't set test_dummy_encryption on remount");
> > > +			 "Can't set or change test_dummy_encryption on remount");
> > >  		return -EINVAL;
> > >  	}
> >
> > I think this needs to be 'fc->purpose == FS_CONTEXT_FOR_RECONFIGURE ||
> > fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)', since ext4 can parse
> > mount options from both s_mount_opts and the regular mount options.
> 
> Sorry, I am missing something here. Could you please help me understand why
> do we need the other OR case which you mentioned above i.e.
> "|| fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)"
> 
> So maybe to put it this way, when will it be the case where
> fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy) is true and it is not a
> FS_CONTEXT_FOR_RECONFIGURE case?

The case where test_dummy_encryption is present in both the mount options stored
in the superblock and in the regular mount options.  See how __ext4_fill_super()
parses and applies each source of options separately.

> Also just in case if I did miss something that also means the comment after this
> case will not be valid anymore?
> i.e.
> 		/*
>          * fscrypt_add_test_dummy_key() technically changes the super_block, so
>          * it technically should be delayed until ext4_apply_options() like the
>          * other changes.  But since we never get here for remounts (see above),
>          * and this is the last chance to report errors, we do it here.
>          */
>         err = fscrypt_add_test_dummy_key(sb, &ctx->dummy_enc_policy);
>         if (err)
>                 ext4_msg(NULL, KERN_WARNING,
>                          "Error adding test dummy encryption key [%d]", err);
>         return err;

That comment will still be correct.

> 
> >
> > > +static void ext4_apply_test_dummy_encryption(struct ext4_fs_context *ctx,
> > > +                                            struct super_block *sb)
> > > +{
> > > +	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
> > > +		return;
> >
> > To handle remounts correctly, this needs to be
> > '!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
> > fscrypt_is_dummy_policy_set(&EXT4_SB(sb)->s_dummy_enc_policy)'.
> 
> Why?
> Isn't it true that in remount we should update EXT4_SB(sb)->s_dummy_enc_policy
> only when ctx->dummy_enc_policy is set. If EXT4_SB(sb)->s_dummy_enc_policy is
> already set and ctx->dummy_enc_policy is not set, that means it's a remount case with no mount
> opts in which case ext4 should continue to have the same value of EXT4_SB(sb)->s_dummy_enc_policy?

struct fscrypt_dummy_policy includes dynamically allocated memory, so
overwriting it without first freeing it would be a memory leak.

- Eric
