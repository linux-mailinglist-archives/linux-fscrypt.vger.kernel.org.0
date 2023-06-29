Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA81741DD0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 03:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjF2Bzx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 21:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2Bzx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 21:55:53 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6892681;
        Wed, 28 Jun 2023 18:55:51 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E6097804D1;
        Wed, 28 Jun 2023 21:55:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688003751; bh=bQ6eASph+jcgawfC0RXE70KZHP/7JJuT8eS7rjqjF84=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=f3LGPKM6Uqcox4emjrUpVdZY5+YYHp0YrZKwpURlgV54BXsA64eBb9IfBa4F1VSWY
         LnDBBurhTY1hxU+3FfN71DI7ZBt4FpW2KDCVARYJq5p2pBcZjjao6/J5hiZJUCZP2W
         Lh7vIc6JD9aVqfocXXbgCi9jJo1oXtA22UXQ6b/wUZkuSXXrvC9hRrco23gc8IzKUs
         7wggXnevbdeu7w+r25EUb1+wRvh1xbrZYZiwSjLUNwsmvCnn82GB80Qad1vZ25M7oX
         bfGTlnCbHmLFg7W95sOrydLREI8Ovml81IjAF7qTal0mfomllayC+knp7lntj97eie
         vyXi9aMUXOJPQ==
Message-ID: <ef0bf9b0-d363-5bd9-6f9f-ab6481795bf4@dorminy.me>
Date:   Wed, 28 Jun 2023 21:55:48 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 09/12] fscrypt: add creation/usage/freeing of
 per-extent infos
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <69695a1673993911f080ea16d565055fa619ffee.1687988246.git.sweettea-kernel@dorminy.me>
Content-Language: en-US
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <69695a1673993911f080ea16d565055fa619ffee.1687988246.git.sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> +	pr_err("fsei1");
Missed this bit of debug; will be fixed in the next version.
