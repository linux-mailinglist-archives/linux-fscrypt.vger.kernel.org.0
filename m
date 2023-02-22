Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DE869FD37
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Feb 2023 21:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBVUxs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Feb 2023 15:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBVUxs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Feb 2023 15:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33C28854;
        Wed, 22 Feb 2023 12:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 337AE61589;
        Wed, 22 Feb 2023 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C1C433D2;
        Wed, 22 Feb 2023 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677099226;
        bh=XaAZIgojzeiPE66ft9Kwkm92/HpTmj5+HTNQ0AOo27w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gx01ffIENhTjEH+tCoh68AnktWvgW+xHzoEXLOtiA0gzRHTgWV9ict/8VkIvfHt4m
         rQFsYPJvu0/lshLOqsAi+vWt2goQna5UaM+g9du+8reCclDR7TktgwxZwMm5uHj/Kp
         nXXrt4uR4bvg6TnSKanMb8eLX5kg82nQnaQxKhxSMXfKiY7JwP8PW0hONTKzHwhyZB
         BRZpmsFM8SjPIW85zXZUzjfK5+CbXHC1aw5BgVg79H+dviWwvmDjgnwbE/gESZ6khF
         jzwUR7SR/qSpU0MxizQM80y82f+RCjH4gTWUrOSYLkvaSYWZt5qK0ZGwAjflzSPA6r
         Fs4+mHm4lcEMA==
Date:   Wed, 22 Feb 2023 20:53:45 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Neal Gompa <ngompa13@gmail.com>, linux-fscrypt@vger.kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC PATCH 00/17] fscrypt: add per-extent encryption keys
Message-ID: <Y/aA2RIFbe++LBSs@gmail.com>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <CAEg-Je-tcpu0u2TekzjrtQ4x0PQtV_1A300WxAiTVswjKbJjYw@mail.gmail.com>
 <6f17b268-6f6a-93dc-e6e0-ac0d982a72e0@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f17b268-6f6a-93dc-e6e0-ac0d982a72e0@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Feb 22, 2023 at 09:13:47AM -0500, Sweet Tea Dorminy wrote:
> > 
> > I'm surprised that this submission generated no discussion across a
> > timeframe of over a month. Is this normal for RFC patch sets?
> 
> Eric pointed out some issues with patches 1 and 15 on 1/2. I've been on
> parental leave and have been busier with new little one than expected, and
> haven't sent out a new version yet. But I'm back to work in a week and this
> is my primary priority.

IMO, most of the patchset will change as a result of addressing my feedback.  So
I haven't had much motivation to review the current version in detail.  I'm
looking forward to the next version; I'm glad you're still working on it!

- Eric
