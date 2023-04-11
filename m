Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410CE6DE661
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 23:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjDKVVJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 17:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjDKVVI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 17:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BA0D8
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 14:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637326260A
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 21:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D7C433EF;
        Tue, 11 Apr 2023 21:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681248064;
        bh=KpWBaqBcUvjF+QYhkqRRo2ZBHhb8WVZDA0MxPH4gaOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tz0Sawwea/JwfM3X6FCSIgf9K7kcRthPHKWWi7Zt/I8ELuVXjH+T0nrjsbRoiaHjF
         XUMNNoAHF9aT0GUDItUKGRvZ9uHSNu1CCoGCp5Jwjw2wV2NuiUztfJ3KS/0Re4CUG1
         k5OgNkvDcZeaPi7DNJ552JxlQdcFRtCtajnRMQIpyIv58pOk62fx0kW5ozCJOjHhf/
         rzbqM1Po+c2Gi81DcwyebM3OGOlJxroTiR+/Df8ENyLAWIdNhGlQObGl12QI+4nL9N
         FUKSZ2u54FevVgIVAPc6lQWzCGp4ppAn+0vd8R+8G6SDuATgZ+pHoENHzMaorKWsAK
         hAGwon2mx/vtg==
Date:   Tue, 11 Apr 2023 21:21:03 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 10/11] fscrypt: explicitly track prepared parts of key
Message-ID: <ZDXPP5lNH74sCoFb@gmail.com>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <2a9bf42af2b2ac6289d0ac886d1f07042feafbe5.1681155143.git.sweettea-kernel@dorminy.me>
 <20230411040551.GI47625@sol.localdomain>
 <0e3d9d01-f185-f6db-792f-a268cc2e04df@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3d9d01-f185-f6db-792f-a268cc2e04df@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 11, 2023 at 12:45:28PM -0400, Sweet Tea Dorminy wrote:
> You're noting that we only really need preparedness for per-mode keys, and
> that's a point I didn't explicitly grasp before; everywhere else we know
> whether it's merely allocated or fully prepared. Two other thoughts on ways
> we could pull the preparedness out of fscrypt_prepared_key and still keep
> locklessness:
> 
> fscrypt_master_key could setup both block key and tfm (if block key is
> applicable) when it sets up a prepared key, so we can use just one bit of
> preparedness information, and keep a bitmap recording which prepared keys
> are ready in fscrypt_master_key.
> 
> Or we could have
> struct fscrypt_master_key_prepared_key {
> 	u8 preparedness;
> 	struct fscrypt_prepared_key prep_key;
> }
> and similarly isolate the preparedness tracking from per-file keys.
> 
> Do either of those sound appealing as alternatives to the semaphore?

Not really.  The bitmaps add extra complexity.  Also note that the tfm and
blk-crypto key do need to be considered separately, as there can be cases where
blk-crypto supports the algorithm but the crypto API doesn't, and vice versa.

I think that for the per-mode keys, we should either keep the current behavior
where prep_key->tfm and prep_key->blk_key aren't set until they're fully ready
(in which case the lockless check continues to be fairly straightforward), *or*
we should make it no longer lockless.

- Eric
