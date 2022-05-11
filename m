Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E3523C00
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345896AbiEKRyl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 May 2022 13:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345636AbiEKRyk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 May 2022 13:54:40 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925B6D85C;
        Wed, 11 May 2022 10:54:39 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 7so2415725pga.12;
        Wed, 11 May 2022 10:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J+H2eREGCzjVdGRqmS4JDyzDPJtfmSBWsZPvnxjv1yA=;
        b=S0K6rWZb7mLzND2OpG/CC1vNDwR8YX+Ah+Ft+6ZO1tNEJhPOY6o/DOrg5srbSP3Vhh
         5fg8sQNM3+Ku+gWvtSOQFLgPTf+iuXpfGeY3t/C4fG6d2ThfkOd/RTq42jS3fEMOQ+VK
         Vg9s6LMxW2NFwMu5J0g9lKuGNhP+I+m0ZIZV6DnVFH6/4WdnVgup8yLxMFdxbQ9+F/nz
         PjiynERLyp6CNCGzbK3wSjwqCAEgZfoD6hfIu/7GYw1O7On2ay7njeYK0H4xctLWORmR
         qBIskGqpvSYvp9S9ur+QW7lErELqeUwuXJnfJFVwNdwERxiWfVWXz07VRFJAsRTG7zNx
         eCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J+H2eREGCzjVdGRqmS4JDyzDPJtfmSBWsZPvnxjv1yA=;
        b=id5eEAvvKkj9g9bSrh/WIbeGZtFaWGKKHSbLNBSqywMWTNXszW8pNDDWJb6+5djJ15
         WSsCAzkk6VFKd016qo8oXZpy2/SFyhWAhAPiqLUkcJ5zAZ9l2MkvwPbWzcdCnyCyYg5e
         Tzha/LpNAiTgPd/JBbuBIaX450ruZUR3UGAiOclmvvMgzJOPq5pJiFMJQadbPON5jfGO
         pfXnQpoyP3XOfQ9vPP8fq56HhPMbr3SfJqiINsINEuz4nex55y43xDrs1RimUdqPB9rl
         2EsfXn8acBCT9IJ+N9S+/6webElxaTsh+040Lu6N7Hq1ZYSiBPxNzaQc2064OERwz9Mo
         UT7w==
X-Gm-Message-State: AOAM531g5J+Cll1BOMimulSlnMav+jvcnc7uZlfTRSHW21ij3sVNevTT
        C1zcFIm7ObGAO92caCfD7iY=
X-Google-Smtp-Source: ABdhPJxvTf7YfIyNEzGmZv/p1CMMuoWqTVhS2Szz6fyjTb/de3Oxd3yWrBoy/3+eAgFG3Hq18uptpw==
X-Received: by 2002:a63:4549:0:b0:3db:5130:d269 with SMTP id u9-20020a634549000000b003db5130d269mr1087854pgk.101.1652291678910;
        Wed, 11 May 2022 10:54:38 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id v11-20020a17090331cb00b0015e8d4eb1dfsm2146273ple.41.2022.05.11.10.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 10:54:38 -0700 (PDT)
Date:   Wed, 11 May 2022 23:24:33 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v2 5/7] ext4: fix up test_dummy_encryption
 handling for new mount API
Message-ID: <20220511175433.inua5nj6l7qtlywq@riteshh-domain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-6-ebiggers@kernel.org>
 <Ynmma+tkA2myRvz6@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynmma+tkA2myRvz6@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/09 04:40PM, Eric Biggers wrote:
> A couple corrections I'll include in the next version:

Need few clarifications. Could you please help explain what am I missing here?

>
> On Sat, Apr 30, 2022 at 10:08:55PM -0700, Eric Biggers wrote:
> > +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> > +		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
> > +						 &ctx->dummy_enc_policy))
> > +			return 0;
> >  		ext4_msg(NULL, KERN_WARNING,
> > -			 "Can't set test_dummy_encryption on remount");
> > +			 "Can't set or change test_dummy_encryption on remount");
> >  		return -EINVAL;
> >  	}
>
> I think this needs to be 'fc->purpose == FS_CONTEXT_FOR_RECONFIGURE ||
> fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)', since ext4 can parse
> mount options from both s_mount_opts and the regular mount options.

Sorry, I am missing something here. Could you please help me understand why
do we need the other OR case which you mentioned above i.e.
"|| fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)"

So maybe to put it this way, when will it be the case where
fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy) is true and it is not a
FS_CONTEXT_FOR_RECONFIGURE case?

Also just in case if I did miss something that also means the comment after this
case will not be valid anymore?
i.e.
		/*
         * fscrypt_add_test_dummy_key() technically changes the super_block, so
         * it technically should be delayed until ext4_apply_options() like the
         * other changes.  But since we never get here for remounts (see above),
         * and this is the last chance to report errors, we do it here.
         */
        err = fscrypt_add_test_dummy_key(sb, &ctx->dummy_enc_policy);
        if (err)
                ext4_msg(NULL, KERN_WARNING,
                         "Error adding test dummy encryption key [%d]", err);
        return err;

>
> > +static void ext4_apply_test_dummy_encryption(struct ext4_fs_context *ctx,
> > +                                            struct super_block *sb)
> > +{
> > +	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
> > +		return;
>
> To handle remounts correctly, this needs to be
> '!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
> fscrypt_is_dummy_policy_set(&EXT4_SB(sb)->s_dummy_enc_policy)'.

Why?
Isn't it true that in remount we should update EXT4_SB(sb)->s_dummy_enc_policy
only when ctx->dummy_enc_policy is set. If EXT4_SB(sb)->s_dummy_enc_policy is
already set and ctx->dummy_enc_policy is not set, that means it's a remount case with no mount
opts in which case ext4 should continue to have the same value of EXT4_SB(sb)->s_dummy_enc_policy?

Did I miss any case here?


-ritesh

>
> - Eric
>
>
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
