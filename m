Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF0D52D152
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 13:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiESLWF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 07:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiESLWE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 07:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55833EB9F;
        Thu, 19 May 2022 04:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4158D61B0D;
        Thu, 19 May 2022 11:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174DC385AA;
        Thu, 19 May 2022 11:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652959321;
        bh=OpQI0301bWKKD5nOghoC8VBmzm7rsdH32HysVf1NgqQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=joaBZKKdAHTEjqvAoAOxSj2x2qw/RlDsQlHgwb8F91MctQyRr5JZQQR4JUh2/WSV/
         +hGhW+wwum9hhtP/yJHdrZIxKRyLJ5qcFqD4b7lKEKOY70hBsVUTDVTHSLkgp/D0SJ
         7hqlcRAW7YVPB83BCvXH5t+HNA50ksFlIeCWCM353Ox2tm3lh0tDVlG3GGXaOiO3wh
         ofWl8To4gJUwGaEJMck4r/4ELsNRb3HGvrte+OIcTLXnGGXwYg7fPwhhm9jlwmE7Lw
         etghlQB/YGn88nMObuYVJx+MPYFhJS0chFB+D+qX2pr7EV4PjPVgcTGRrQ/AflL8MX
         fL4xTvFSDaWlw==
Message-ID: <5c9b94f4-28f4-9f3c-8cc7-b0b09270b91a@kernel.org>
Date:   Thu, 19 May 2022 19:21:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [f2fs-dev] [PATCH v3 4/5] f2fs: use the updated
 test_dummy_encryption helper functions
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20220513231605.175121-1-ebiggers@kernel.org>
 <20220513231605.175121-5-ebiggers@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220513231605.175121-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2022/5/14 7:16, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Switch f2fs over to the functions that are replacing
> fscrypt_set_test_dummy_encryption().  Since f2fs hasn't been converted
> to the new mount API yet, this doesn't really provide a benefit for
> f2fs.  But it allows fscrypt_set_test_dummy_encryption() to be removed.
> 
> Also take the opportunity to eliminate an #ifdef.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
