Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94A1EFE2A
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Jun 2020 18:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFEQog (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Jun 2020 12:44:36 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17131 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFEQog (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Jun 2020 12:44:36 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1591375466; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ELo3/lzYaUF89cicNcyelYORjaAY1C9FGrt3i3qCD3OoEGSLY2BHkg2AdWFfToMYXmsuYchvSwqFoUg68opX61Y8H1aAYIWk6cxa6gtpDkFL4ZsaOZMW4JLwAtVY76ptng8mGiJuoJPCpsrpBQXX0r3d8EXjBF4tmZBVQeje69U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1591375466; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JlupnKgBleJjhUIv/2J8Fq2LwQHTVuB5+8dlngYSaIc=; 
        b=GgL2y4HwXABw0BbHTZxrCcK7p/P1k5LtIFdlkhuLA3C8AagEfTXYfyNgTup4EFB00stKHdfXU2HlZsF3P3+O/U9+woXFSkSpfB/kPiYl8rnhRC1god4xEaLZXukfa1aSCSeD6+chGDLJgAz3dRGTmvfgg67TbQ4uSDBZFGZHp0I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [100.108.78.247] (163.114.132.6 [163.114.132.6]) by mx.zoho.eu
        with SMTPS id 1591375464640189.93703033431314; Fri, 5 Jun 2020 18:44:24 +0200 (CEST)
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200525205432.310304-1-ebiggers@kernel.org>
 <20200527211544.GA14135@sol.localdomain>
 <6c829c1c-9197-122f-885c-20157b2b4c22@trained-monkey.org>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ad30cd43-3452-e6ba-7de0-19084acd23b5@trained-monkey.org>
Date:   Fri, 5 Jun 2020 12:44:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6c829c1c-9197-122f-885c-20157b2b4c22@trained-monkey.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/28/20 9:22 AM, Jes Sorensen wrote:
> On 5/27/20 5:15 PM, Eric Biggers wrote:
>> On Mon, May 25, 2020 at 01:54:29PM -0700, Eric Biggers wrote:
>>> From the 'fsverity' program, split out a library 'libfsverity'.
>>> Currently it supports computing file measurements ("digests"), and
>>> signing those file measurements for use with the fs-verity builtin
>>> signature verification feature.
>>>
>>> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
>>> I made a lot of improvements; see patch 2 for details.
>>>
>>> This patchset can also be found at branch "libfsverity" of
>>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/
>>>
>>> Changes v1 => v2:
>>>   - Fold in the Makefile fixes from Jes
>>>   - Rename libfsverity_digest_size() and libfsverity_hash_name()
>>>   - Improve the documentation slightly
>>>   - If a memory allocation fails, print the allocation size
>>>   - Use EBADMSG for invalid cert or keyfile, not EINVAL
>>>   - Make libfsverity_find_hash_alg_by_name() handle NULL
>>>   - Avoid introducing compiler warnings with AOSP's default cflags
>>>   - Don't assume that BIO_new_file() sets errno
>>>   - Other small cleanups
>>>
>>> Eric Biggers (3):
>>>   Split up cmd_sign.c
>>>   Introduce libfsverity
>>>   Add some basic test programs for libfsverity
>>>
>>
>> Applied and pushed out to the 'master' branch.
> 
> Awesome, any idea when you'll be able to tag a new official release?

Hi Eric,

Ping, anything holding up the release at this point?

Sorry for nagging, I would really like to push an updated version to
Rawhide that can be distributed as a prerequisite for the RPM changes.

Thanks,
Jes

