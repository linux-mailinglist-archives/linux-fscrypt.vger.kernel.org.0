Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5F4606AFD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 00:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJTWHZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 18:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJTWHY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 18:07:24 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA9228CFE;
        Thu, 20 Oct 2022 15:07:17 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 0B56E80040;
        Thu, 20 Oct 2022 18:07:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666303636; bh=Dew6TNVSoSgbDs9HCoToB1PtD3DTROPiNxTFdLq0Y4g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XBcoCUopRUAXTozTQ4RsfYxWFgCzYSvbZppwNLv9OKVHQ0FTH3Y1gsv1qlAENINp2
         mUvQIPz742UlRRQnDT5ML9jjRUtCW5kPGN9dPKE91UeJIOiJbqn2bgVtJOA7VoMRBt
         XXr0wAdnWwrjoFf3v0ChVSupkRlpY1QeY/DBShWA7rT+4l7xcKQVjlpib1U3GSjyTM
         TAce24mFlO4rJRp8qbUJqKlIdcpaDXGnLX3quMlLTBJb79BWPXHG1SUbY7sCZaItTN
         BA2cqlMAoantQz2xQFUS3ggfQK/QUdgW7V5c6f5zB6qWIT5DlHbqKEsfIMu4a2VUre
         B2incInhwDZAQ==
Message-ID: <ebb79be7-5bab-8a07-254d-16a603315388@dorminy.me>
Date:   Thu, 20 Oct 2022 18:07:13 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v3 05/22] fscrypt: document btrfs' fscrypt quirks.
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <6ffe9471b0caedf1e134d417644d2b3d1a273799.1666281277.git.sweettea-kernel@dorminy.me>
 <Y1HApkGv06Bnjv+i@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y1HApkGv06Bnjv+i@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/20/22 17:41, Eric Biggers wrote:
> On Thu, Oct 20, 2022 at 12:58:24PM -0400, Sweet Tea Dorminy wrote:
>> +For most filesystems, fscrypt does not support encrypting files
>> +in-place.  Instead, it supports marking an empty directory as encrypted.
>> +Then, after userspace provides the key, all regular files, directories,
>> +and symbolic links created in that directory tree are transparently
>>   encrypted.
> 
> As I mentioned on the previous version, I'd prefer if the support for encrypting
> nonempty directories was at the end of the patchset.
> 
> - Eric

Ah, you're right, I should split the doc change about non-empty 
directories into its own change. Will do.
