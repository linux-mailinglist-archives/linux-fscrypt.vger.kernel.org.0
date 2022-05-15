Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1116152753A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiEODkU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 23:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiEODkP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 23:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57DC63C8;
        Sat, 14 May 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 510E1B8092E;
        Sun, 15 May 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A8BC385B8;
        Sun, 15 May 2022 03:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652586012;
        bh=vctj2+0wvUW55E9dEnKTHl4kLLfdgsWG+SrnwEvrscI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TjIhQNDk3mPgibRYhXARpbj/+iC21qFPc234OhgexE7kDnuu4ry9etaOZEwnGVvFq
         MOdpE6UV9YDqz70TRuuVK7zFYo114Vi/rArePdYgBmGVLTVRl0h0TSN+djYExO31Pu
         j9Bsc27gWhVO+UoE4/TkYZdhKZ5sylW43hOb4y1lCGI9N3vLgpqYkYnP8o8Siwv5Mk
         YbNpudRZLSc18JtX23fHHNckTtcGZiPbQ98SglJuY8rF4ec2vWdaeF1hkpewDhR6p8
         tvEsEHcaRehOSahTXAcHeEQC7hc9bKbgSb/1S1ffosZXttUxYAvLseyI1TFo5vUq2q
         761i6Cu/F4Cqw==
Date:   Sat, 14 May 2022 20:40:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 2/3] ext4: Cleanup function defs from ext4.h into
 crypto.c
Message-ID: <YoB2Glboi8Kcu+Ak@sol.localdomain>
References: <cover.1652539361.git.ritesh.list@gmail.com>
 <4120e61a1f68c225eb7a27a7a529fd0847270010.1652539361.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4120e61a1f68c225eb7a27a7a529fd0847270010.1652539361.git.ritesh.list@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, May 14, 2022 at 10:52:47PM +0530, Ritesh Harjani wrote:
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
[...]
> +int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
> +			      int lookup, struct ext4_filename *fname)
> +{
[...]
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
[...]
> +int ext4_fname_setup_filename(struct inode *dir,
> +			      const struct qstr *iname, int lookup,
> +			      struct ext4_filename *fname);

Very minor nit: the above declaration can be formatted on 2 lines, the same as
the definition.

Otherwise this patch looks fine.  I think that filename handling in ext4 in
general is still greatly in need of some cleanups, considering that ext4 now has
to support all combinations of encryption and casefolding.  f2fs does it in a
somewhat cleaner way, IMO.  And it's possible that would lead us down a slightly
different path.  But this is an improvement for now.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
