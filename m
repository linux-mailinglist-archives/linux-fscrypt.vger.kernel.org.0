Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959A56DCBBC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDJTkr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDJTkq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:46 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7FF10D7
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:46 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3139580510;
        Mon, 10 Apr 2023 15:40:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155645; bh=fFMJvVEufVlESgN92L79IOAyLa0efUJtrrb7ebfD52o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gRMnCa4h7c1XvTzVcAIC9G5ymjg40ve/BBo0cDrkguYQnyWnpH/5NYBJ/NTc8+8gD
         FCglW721oam4jPHm7LTYnaZlyV9dBXacscNUrdGZA0/jboap/WQ2mp0FctfPpRWia5
         YNtLcQaXYnov6RPnNJDZ21aKOGFcuaZeNLOa2OSWNX4u2VyAZsccAD+38vZYQgWfad
         feJfrci3VLFLQ+a2QGFhRDfTOGi8srVdwB3tn544yIuHPVUj1vV0HTyvjBtqauqKFZ
         3U7tDkQ8gJa5wZHVwc+yabvoNEKYl/JNn9XwWS+GION61ruTmDY8hN97UMqXX47i9Z
         MyA611PFjJLpQ==
Message-ID: <09e5e77b-5f37-9d93-51fd-1d9d39b219b2@dorminy.me>
Date:   Mon, 10 Apr 2023 15:40:44 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 00/10] fscrypt: rearrangements preliminary to extent
 encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@meta.com
References: <cover.1681116739.git.sweettea-kernel@dorminy.me>
 <ZDRhQGYfOsJjzbjx@gmail.com>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <ZDRhQGYfOsJjzbjx@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/10/23 15:19, Eric Biggers wrote:
> On Mon, Apr 10, 2023 at 06:16:21AM -0400, Sweet Tea Dorminy wrote:
>> Patchset should apply cleanly to fscrypt/for-next
> 
> It doesn't apply.  What is the base commit?

Apologies, I dropped the first patch. Resending.

