Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810A27BD26B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Oct 2023 05:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbjJIDoV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 8 Oct 2023 23:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbjJIDoU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 8 Oct 2023 23:44:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2E4A6;
        Sun,  8 Oct 2023 20:44:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81930C433C8;
        Mon,  9 Oct 2023 03:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696823058;
        bh=qVDrf/trx8sq31i+yhHFC8rDIRV+sneM9PcsiTpytoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TSQ+Vig+v4Be77+/Dfu8Mh3kqpObFlaQ/ZPgqxjGOAxc3E2jiBYrs08M0w2bKE2p9
         YDFlSt0CDwHbPUmBojFAcB0DMm1yyMkDom3HnuVlSAFekexQCpzSDGX0Yryb2Y5WVB
         OUuLktWWM282XMBdlwvtfVODR8xwUdTyfKAqkWLQ6OYbBOXgWTUtxnZK8zYXeLDQpz
         ZrD4lSEDOwGo/BnWwcWTlF4aPT5BTte+/xrZIO50QvBGJ80+R3Q0fgTxSKOMtIwwLu
         rdm1yYeFS9PYip5hnatBwKZ8/BHqgpAfknxjMPxOOisOlmiKijVOdObD0aNwNfxRNc
         R4tCqGRJeCIdQ==
Date:   Sun, 8 Oct 2023 20:44:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Neal Gompa <neal@gompa.dev>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] fscrypt: rename fscrypt_info => fscrypt_inode_info
Message-ID: <20231009034416.GA279961@sol.localdomain>
References: <20231005025757.33521-1-ebiggers@kernel.org>
 <CAEg-Je9giOLBVwuXAQ+F6do7sTBcCpP_ARbGA6TowTT+6GBc4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEg-Je9giOLBVwuXAQ+F6do7sTBcCpP_ARbGA6TowTT+6GBc4g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Oct 08, 2023 at 02:11:36AM -0400, Neal Gompa wrote:
> 
> Looks reasonable to me.
> 
> Reviewed-by: Neal Gompa <neal@gompa.dev>
> 

Thanks.  BTW, please only quote the part that you're replying to.

- Eric
