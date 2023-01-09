Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA740662EBC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Jan 2023 19:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbjAISVs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Jan 2023 13:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbjAISVU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Jan 2023 13:21:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF5FB1C6;
        Mon,  9 Jan 2023 10:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD334612F3;
        Mon,  9 Jan 2023 18:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C2DC43396;
        Mon,  9 Jan 2023 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673288404;
        bh=TcyccvaeWIJ1n/7OY3DOeV8jgc1GnmZNRcCr4B2Pu9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZUtb+F4k2D86Z0BtUDEQmpp0/csf/BSsC0htQGiv6lUiuoAJ1BW0+4l9Pj8aF5Kj
         rl8TMx1+hGY/AgRsuhOMgja5ARZHFdZGYeSLSsVqJKwd2u5kY7XQa0l0KzikGj6L1D
         Ru3B9KGbR8SIWBypeKBWlaL6yRGJn+Fr9QiSOsq7bAPs/D7ojHBTnCkHEaFm7BgXIO
         9fEaZVIsGMFs+ZfgpmtKHFoWDCY0mE2a4jeAvJCCWVRBGeGUWXZoTm+fqhfZvvOHTA
         uYsfOaKhH8Jc05BQ3nEpnZGz/Z44NqZMzOgXPr3SH2gFYo/QHThMWG0AO0Dk3mvbLE
         uP3/Aq/RsWGSQ==
Date:   Mon, 9 Jan 2023 10:20:02 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [e2fsprogs PATCH v2] e2fsck: don't allow journal inode to have
 encrypt flag
Message-ID: <Y7xa0h2f9BamOWMa@sol.localdomain>
References: <20221102220551.3940-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102220551.3940-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 02, 2022 at 03:05:51PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since the kernel is being fixed to consider journal inodes with the
> 'encrypt' flag set to be invalid, also update e2fsck accordingly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: generate the test filesystem image dynamically.

Ping.

- Eric
