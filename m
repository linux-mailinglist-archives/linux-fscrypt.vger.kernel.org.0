Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF9523B54
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbiEKRSp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 May 2022 13:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244095AbiEKRSo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 May 2022 13:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977CF68FB2;
        Wed, 11 May 2022 10:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1515661D42;
        Wed, 11 May 2022 17:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C70C34113;
        Wed, 11 May 2022 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652289522;
        bh=dtt51r4FC8J4L/dpuNqjEYl6pzvtBwAn3jhFVusBWWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oUnj8zqjKAopFQqGYTk6FFowSyKG3lS3+ydTHHjwyq4HNTs2ZQJbRQFPx0h4nd+bl
         CJYZTaaZlX7RDk429hT8CNfZScyz5nSuCBthURoMGDlmbuZ1lb1CsHLkbdI4KeZTjE
         V4qWjRLFEh/TlecDQBqAajV96TTQbdp0lFmOgmhOOqVjm45zaQAnqwH5w/mPrNlQXc
         VnaZvm2KAng84KRhZOe8+00Crxf6AUXV2HeEzmaJgNasZN3w7/XuZ8w1rLHa2XBAXt
         o9tcnG40Obo/u8VsWAWg7oYdJjwzYnBqjjkETjdt5IenTFj0FDRmM4N8ajvcpTf/ZI
         jyFKAMn2NBHow==
Date:   Wed, 11 May 2022 17:18:34 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/7] ext4: only allow test_dummy_encryption when
 supported
Message-ID: <Ynvv6nf5rWmKItSL@gmail.com>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-2-ebiggers@kernel.org>
 <20220511125023.gxfkgft35gkjyhef@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511125023.gxfkgft35gkjyhef@riteshh-domain>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 11, 2022 at 06:20:23PM +0530, Ritesh Harjani wrote:
> > +static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
> > +					    struct super_block *sb)
> 
> Maybe the function name should match with other option checking, like
> ext4_check_test_dummy_encryption_consistency() similar to
> ext4_check_quota_consistency(). This makes it clear that both are residents of
> ext4_check_opt_consistency()
> 
> One can argue it makes the function name quite long. So I don't have hard
> objections anyways.
> 
> So either ways, feel free to add -
> 
> Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>

I did consider that, but that name seemed too long, as you mentioned.

Thanks for the review!

- Eric
