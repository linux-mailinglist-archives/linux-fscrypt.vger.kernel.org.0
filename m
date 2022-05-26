Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E08A53531F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 May 2022 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiEZSIX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 May 2022 14:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiEZSIW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 May 2022 14:08:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F6DAEE1F;
        Thu, 26 May 2022 11:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D96B821A7;
        Thu, 26 May 2022 18:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCF6C385A9;
        Thu, 26 May 2022 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653588498;
        bh=E3Ww4J7ex7feyt/PK95NAWt8/v/PhCWPmrrUafnm9i4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YCn2UACqA/DvxyLQatFA9Qe7CW2bCF/79cMUvMAz++b1yU8W5zwMqPMbHoc8lPTST
         Cz8B3HqWOeGp0iuCp3/O7kLSJ+uacdYpz3Q5wBNF9xPrt4NaG1mMoq6UY5H3yJ+BvB
         1wvcFPoA2UST2XJm7kStlFmO6RNIfXFy6R8U3stUSU4IovthNRMjEFbh/rNbULEmmt
         HzStMalQfwFni2ziF/H1xQsXwbQDDPt8hwT3G+UULdF44Xcl8UYVWvyRLR4eB9PlPq
         Kt4uuuayI0EOnrG4SaRGewAnVAhW9uckttftri6Q/q+HY2ue8BkPHoXtJ1rLJc5EoH
         fuuH18nRCKeOA==
Date:   Thu, 26 May 2022 11:08:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fscrypt@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v4] ext4: fix up test_dummy_encryption handling for new
 mount API
Message-ID: <Yo/CEPx93S0k6TgB@sol.localdomain>
References: <20220526040412.173025-1-ebiggers@kernel.org>
 <20220526085507.mmxndcypsa756eap@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526085507.mmxndcypsa756eap@fedora>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[Please use reply-all, not reply!]

On Thu, May 26, 2022 at 10:55:07AM +0200, Lukas Czerner wrote:
> On Wed, May 25, 2022 at 09:04:12PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Since ext4 was converted to the new mount API, the test_dummy_encryption
> > mount option isn't being handled entirely correctly, because the needed
> > fscrypt_set_test_dummy_encryption() helper function combines
> > parsing/checking/applying into one function.  That doesn't work well
> > with the new mount API, which split these into separate steps.
> > 
> > This was sort of okay anyway, due to the parsing logic that was copied
> > from fscrypt_set_test_dummy_encryption() into ext4_parse_param(),
> > combined with an additional check in ext4_check_test_dummy_encryption().
> > However, these overlooked the case of changing the value of
> > test_dummy_encryption on remount, which isn't allowed but ext4 wasn't
> > detecting until ext4_apply_options() when it's too late to fail.
> > Another bug is that if test_dummy_encryption was specified multiple
> > times with an argument, memory was leaked.
> > 
> > Fix this up properly by using the new helper functions that allow
> > splitting up the parse/check/apply steps for test_dummy_encryption.
> > 
> > Fixes: cebe85d570cf ("ext4: switch to the new mount api")
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> 
> Hi, thanks for the patch it looks good, exept maybe small consideration
> below...
> 
> > @@ -2673,11 +2656,11 @@ static int ext4_check_quota_consistency(struct fs_context *fc,
> >  static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
> >  					    struct super_block *sb)
> >  {
> > -#ifdef CONFIG_FS_ENCRYPTION
> >  	const struct ext4_fs_context *ctx = fc->fs_private;
> >  	const struct ext4_sb_info *sbi = EXT4_SB(sb);
> > +	int err;
> >  
> > -	if (!(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
> > +	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
> 
> how about
> 
> 	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
> 	    fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
> 					 &ctx->dummy_enc_policy))
> 		return 0;
> 
> and remove the two fscrypt_dummy_policies_equal checks below?
> 
> But regardless whether you want to change it, you can add
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 

That would work, but I think the code I've proposed makes it a little more
explicit what's going on.

- Eric
