Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4708526065
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 May 2022 12:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbiEMK7B (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 06:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiEMK7B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 06:59:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BEC2A1891;
        Fri, 13 May 2022 03:58:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so10487860pju.2;
        Fri, 13 May 2022 03:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=670hcE2fJNGTjVHjkhPxwd9sqgqL5UB9w/AupduhwRI=;
        b=ftN0kv6VoGPs94xZoXK6CrFIdgCyMxHHdDYC/VGuagRTWfNjV11qMM5iZrCMOCZbaP
         ibeOa/R/5pFi3HsOJFBUNTlW00Vv9pZ8mRm1mjj7ooZeXNWskJ2IeCtzqChhxeHfjBAK
         b0akZLATKZfkGhqzS0cs/S9EzD+Do375mFcbmBUJaaeGH2OwAggEDz6noqkkhevjtR34
         j5x2mb4uAzebXeKlaxid2uh0lz560tM3tgDkzLB5ATjVTuu4NX4uYZOYrLdM7g2ZLmAM
         YuGjHEfFuWFCk2RWshLi5IQVizgqgKuyJpWZOdQ8Chx2uD9HOumt0onlIdb5AtIrw6SA
         7/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=670hcE2fJNGTjVHjkhPxwd9sqgqL5UB9w/AupduhwRI=;
        b=3THk3kBBdZe7+sDkYp6HA6pByKKoWcgOyhe5Mco6FqzoFnIVM0H58qmwyNkAk0+8gi
         0IRA9jztaMceNZ9pumc+MsI6V90KS0r5c6Kw9X6PdG020h171dfPPGjb7yr33ttwYbg3
         tIaRPhDEzwY4Bc0ViXldd1SST9VdffOIWKy+OiVOf7tkeNl0tIlS4hWBJbCEN1OJb4aL
         zI3gNS+0wzFo+ThPCqoxq3TsIoo5bosS2qRx+jTfSPffZGqZyR+X051XwfbPRYreArcm
         ppMd0nQT8vf4qT73kkwgwFoTNpr+1/66ZEY6SfQiqcXUHxQvyZoZDuK1nrrCY76o4V+y
         0SYw==
X-Gm-Message-State: AOAM532BdV1BHgUcnVvpXMzVOmSs0kYPDmCwkZMIaR+f0Ox4xF0aHz89
        +JY4E2BRJ+wsq71Z4DXzgfUhqzdz/ow=
X-Google-Smtp-Source: ABdhPJwKTYkxXDl1r01LTMdFkfTSkql8+KXT3A0OBgS/YZRo35yOTeWGHL33ZRmPYEsuLvh70ySkPw==
X-Received: by 2002:a17:90b:3a86:b0:1dc:2343:2429 with SMTP id om6-20020a17090b3a8600b001dc23432429mr4340346pjb.206.1652439539190;
        Fri, 13 May 2022 03:58:59 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id v6-20020a63f846000000b003c14af5060asm1377045pgj.34.2022.05.13.03.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 03:58:58 -0700 (PDT)
Date:   Fri, 13 May 2022 16:28:53 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v2 5/7] ext4: fix up test_dummy_encryption
 handling for new mount API
Message-ID: <20220513105853.v7iw2mbi3ycg2rqg@riteshh-domain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-6-ebiggers@kernel.org>
 <Ynmma+tkA2myRvz6@sol.localdomain>
 <20220511175433.inua5nj6l7qtlywq@riteshh-domain>
 <Ynv6dRdf3vZH7v2W@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynv6dRdf3vZH7v2W@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/11 06:03PM, Eric Biggers wrote:
> On Wed, May 11, 2022 at 11:24:33PM +0530, Ritesh Harjani wrote:
> > On 22/05/09 04:40PM, Eric Biggers wrote:
> > > A couple corrections I'll include in the next version:
> >
> > Need few clarifications. Could you please help explain what am I missing here?
> >
> > >
> > > On Sat, Apr 30, 2022 at 10:08:55PM -0700, Eric Biggers wrote:
> > > > +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> > > > +		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
> > > > +						 &ctx->dummy_enc_policy))
> > > > +			return 0;
> > > >  		ext4_msg(NULL, KERN_WARNING,
> > > > -			 "Can't set test_dummy_encryption on remount");
> > > > +			 "Can't set or change test_dummy_encryption on remount");
> > > >  		return -EINVAL;
> > > >  	}
> > >
> > > I think this needs to be 'fc->purpose == FS_CONTEXT_FOR_RECONFIGURE ||
> > > fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)', since ext4 can parse
> > > mount options from both s_mount_opts and the regular mount options.
> >
> > Sorry, I am missing something here. Could you please help me understand why
> > do we need the other OR case which you mentioned above i.e.
> > "|| fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)"
> >
> > So maybe to put it this way, when will it be the case where
> > fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy) is true and it is not a
> > FS_CONTEXT_FOR_RECONFIGURE case?
>
> The case where test_dummy_encryption is present in both the mount options stored
> in the superblock and in the regular mount options.  See how __ext4_fill_super()
> parses and applies each source of options separately.

Ok, thanks for clarifying. So this says that
1. in case of mount; if test_dummy_encryption is already set with some policy in
   the disk superblock and if the user is trying to change the mount option in
   options string, then that is not allowed.
2. Similarly if while remounting we try to change the mount option from the
   previous mount option, then again this is not allowed.


>
> > Also just in case if I did miss something that also means the comment after this
> > case will not be valid anymore?
> > i.e.
> > 		/*
> >          * fscrypt_add_test_dummy_key() technically changes the super_block, so
> >          * it technically should be delayed until ext4_apply_options() like the
> >          * other changes.  But since we never get here for remounts (see above),
> >          * and this is the last chance to report errors, we do it here.
> >          */
> >         err = fscrypt_add_test_dummy_key(sb, &ctx->dummy_enc_policy);
> >         if (err)
> >                 ext4_msg(NULL, KERN_WARNING,
> >                          "Error adding test dummy encryption key [%d]", err);
> >         return err;
>
> That comment will still be correct.
>
> >
> > >
> > > > +static void ext4_apply_test_dummy_encryption(struct ext4_fs_context *ctx,
> > > > +                                            struct super_block *sb)
> > > > +{
> > > > +	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
> > > > +		return;
> > >
> > > To handle remounts correctly, this needs to be
> > > '!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
> > > fscrypt_is_dummy_policy_set(&EXT4_SB(sb)->s_dummy_enc_policy)'.
> >
> > Why?
> > Isn't it true that in remount we should update EXT4_SB(sb)->s_dummy_enc_policy
> > only when ctx->dummy_enc_policy is set. If EXT4_SB(sb)->s_dummy_enc_policy is
> > already set and ctx->dummy_enc_policy is not set, that means it's a remount case with no mount
> > opts in which case ext4 should continue to have the same value of EXT4_SB(sb)->s_dummy_enc_policy?
>
> struct fscrypt_dummy_policy includes dynamically allocated memory, so
> overwriting it without first freeing it would be a memory leak.

Ok yes. Since this is dynamic memory allocation. Hence
I see that ext4_apply_test_dummy_encryption() can be called from
parse_apply_sb_mount_options(), __ext4_fill_super() and __ext4_remount().

Case 1: when this mount option is set in superblock
1. So in parse_apply_sb_mount_options(), this mount option will get set the
   first time if it is also set in superblock field.

2. So if we also have a same mount option set in regular mount,
   or during remount both will have sbi->s_dummy_enc_policy already set (from
   step 1 above), so we should do nothing here.

Case 2: when this mount option is passed as regular mount
1. parse_apply_sb_mount_options() won't set this.
2. __ext4_fill_super() will set this mount option in sbi and hence __ext4_remount
   should not set this again.

And as I see you are cleverly setting memset &ctx->dummy_enc_policy to 0
in case where we applied the parsed mount option to sbi. So that the actual
policy doesn't get free when you call __ext4_fc_free() after ext4_apply_options()
in parse_apply_sb_mount_options(). And in other cases where this mount option was
not applied to sbi mount opt, in that case we anyway want this policy to get
free.

This somehow looks very confusing to me. But I guess with parse, check and apply
mount APIs and with mount options in superblock, regular and remount path, this
couldn't be avoided (although I am no expert in this area).

Thanks for explaining. I hope I got this right ;)

-ritesh
