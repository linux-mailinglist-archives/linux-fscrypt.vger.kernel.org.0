Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC2526CB7
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 00:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384798AbiEMWAD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 18:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384799AbiEMWAC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 18:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091D84E387;
        Fri, 13 May 2022 15:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A72460DE3;
        Fri, 13 May 2022 22:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51F8C34100;
        Fri, 13 May 2022 21:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652479200;
        bh=9or3bcCS+phDNhSoucSJa5LZj2NNYNIkPfIS1dsSmy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0nvUTpYk1zVtYoddcOJhYOp76M/RWg1R9jV/CF4DJxjPW7eSUZyHABBUBoqNTpyg
         RVWnCAxWXoOCnMjf0pyzW1zvnJUjV6Bh5e+hrmBxzNusD/jmysfkC86tD5j+G9LgpI
         hpCcB0tZ8BEMqi79uP/N6qTpkQqpqyZLFmOyYA3Zwge1f2OgX6s2Qg7bfg/msh7Dx2
         kcCb1zrQHdehUzaWNn93F2yjIO8Sji/UCPhaQ4Xitcu74QG0I+MKpILk0GtmFIsdeJ
         Cufl9ISLi7mV7fJJYdc8uH92O0XtIRrVqYEDTTHPeigBnsCjllXvLO2XVfo6x0kfW3
         W1fXrCYiDou4w==
Date:   Fri, 13 May 2022 14:59:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 5/7] ext4: fix up test_dummy_encryption handling for
 new mount API
Message-ID: <Yn7U3YHQfoRaeQPQ@sol.localdomain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-6-ebiggers@kernel.org>
 <20220513110741.uofbacfs7li4cqio@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513110741.uofbacfs7li4cqio@riteshh-domain>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 13, 2022 at 04:37:41PM +0530, Ritesh Harjani wrote:
> > @@ -2623,10 +2609,11 @@ static int parse_apply_sb_mount_options(struct super_block *sb,
> >  	if (s_ctx->spec & EXT4_SPEC_JOURNAL_IOPRIO)
> >  		m_ctx->journal_ioprio = s_ctx->journal_ioprio;
> >
> > -	ret = ext4_apply_options(fc, sb);
> > +	ext4_apply_options(fc, sb);
> > +	ret = 0;
> >
> >  out_free:
> > -	kfree(s_ctx);
> > +	__ext4_fc_free(s_ctx);
> 
> I think we can still call ext4_fc_free(fc) and we don't need __ext4_fc_free().
> Right?
> 

Yes, you're right.  I might have missed that fc->fs_private was being set above.
I was also a little lazy here; the part below 'out_free:' should be a separate
patch since it also fixes a memory leak of s_qf_names.  I'll fix that up.

- Eric
