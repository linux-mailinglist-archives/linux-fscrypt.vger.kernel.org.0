Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D015AF82F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 01:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIFXBX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Sep 2022 19:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiIFXBV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Sep 2022 19:01:21 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81D7832D0;
        Tue,  6 Sep 2022 16:01:19 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id B96838012D;
        Tue,  6 Sep 2022 19:01:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662505279; bh=Gm6Z4rktcdhl6M/t8xIkjvCarKNB6AtVzn7QxfG3R44=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jZ7ir6JIZyv3Hp2csYqeWm6PjPiEtOiRc6NbAa3uK5/wWO7zDqv4Iis4NWd44IRWC
         ksnU5B4sdWUstcFIIJIx1h11aXd87oYS7zAWTHEkpJ7zbhMlloYxH3k3UXYERG/ZeV
         aDWsNPeEfiN6k2D/J7RyYFwqomGgzFnXOk55YPZNLDZDIQO8KqDqoPNRCHRA+COQ9N
         tOrKGwJU2AcYi/Q03aanMSgJYLn0Uf9IzDR9W8cZYtInwoKBx0vJ/tX6lZHaVj8HO9
         lUEg8wOsUSXoNleS4lFrXaghdrWDTjMC9TZD0RXdphbJTNLvyqssbRq+l5UPMsr8Xj
         XjFnhgkPPT9gA==
Message-ID: <d1718c87-cec0-1796-8585-e89f28a8d3bd@dorminy.me>
Date:   Tue, 6 Sep 2022 19:01:15 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/20] btrfs: add fscrypt integration
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <YxfLQzL9BYnxwaXQ@quark>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <YxfLQzL9BYnxwaXQ@quark>
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



On 9/6/22 18:35, Eric Biggers wrote:
> On Mon, Sep 05, 2022 at 08:35:15PM -0400, Sweet Tea Dorminy wrote:
>> This is a changeset adding encryption to btrfs.
> 
> What git tree and commit does this apply to?

https://github.com/kdave/btrfs-devel/; branch misc-next. Should apply 
cleanly to its current tip, 76ccdc004e12312ea056811d530043ff11d050c6 .
