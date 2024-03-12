Return-Path: <linux-fscrypt+bounces-250-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EC1879BEB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 19:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33F421F212FB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 18:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F7F1420D1;
	Tue, 12 Mar 2024 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="r6rigTx1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E671419B5
	for <linux-fscrypt@vger.kernel.org>; Tue, 12 Mar 2024 18:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710269488; cv=none; b=JHvajktZ57TMAxIaP35tetQmcdBYS10J5F089FLBPhXYOOoCPKafbLpXRI2s3atNcf68WaAdngxZMpeelQhig8QHM73NV45PCiZWMLF8PHy6hg0PhOikNSmp2WZCFp8FXzdVYNbkMP1XVDw0HNjr6wh26dLnC4DRcycG7o02E6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710269488; c=relaxed/simple;
	bh=lYJ68qCJj9s6NmpqrgZ2poblEliQVIufa8sFiTqeojI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxO8F8wrDCPXFGUNKEmCJiB8cBFYPkteWJ6FGFRziNASS/sTkmuES8TrzmITFnX17z5ZOne+nksMm1KnjzYJM/sd7YLKCC36Eh4NkOr1EjXEJUEBkSRvUHrfUuJv9HS2DaqpK5VbqehZypG1k84CXGE8I0xckG2FKOMJn/r4cq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=r6rigTx1; arc=none smtp.client-ip=66.163.189.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1710269485; bh=lYJ68qCJj9s6NmpqrgZ2poblEliQVIufa8sFiTqeojI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=r6rigTx14JPynU5qRTWbh+by/HS9qNFry+a2PuixUw5RPmaPHTwiex8hw7fkbY59as9GeXqIReuTShMsD42FN3NHXgaE+9Rp46pY6FlcRlIROgyCujKDKX4ciWF+c1DINQsf7hmrtgIIkfrXpDjS4GVOsBQEaYAb+r/iAwrrpABlfPZutbh8lYuJ0NY5s2+SVuv3OF+6EN+xNJcDa5vuGLQqzIoH7OFoPv4E8gBxXE7kO2mKqLQHQkArMa2h5bXViAeGJ1GrvxG1iP52sjuKHin++yqUSxKe2f7pzGEsJh1oosp07186m59UXbGjxWV12Cf94ZtSXv1paFrJNPUeeg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1710269485; bh=guznvln6aQ2vnACE+hk5PJrBA1s9s67fzj015pktdNu=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=tByuAvMGTBqoDE5okVLbCCCZnOk7fUFenkPFmR5edu/Zv1Bp4+iB+yHx6SfA+br3Vj+XU3M86TzPUMJ0GQg/gRgRVIJZcBKBmlVAhu9MDB0E2Ft/OAngpKPGlYBL4oFG0AgRPJm7IlBlCaHrotBebzcG/dsD1F0jyHip1EoxGX0fPLEehjV21zlWNbLRCVO+toHFdX7ZqspO/vdmzG98fIYtr7lchYV5zXLpfDTWIL1VrWyZRAw2TaDpqn22OZNRtBuLQ+B2yr7781pIvUWz3Uzr1bzg7P8YYesuIQnQQTHtmHniCf3h1kV6DEHslPqmkapgt8r9Tjx8H7r8tfzduA==
X-YMail-OSG: lvVQTiQVM1lOLlRRmW7u8PSQ.K_cKDF6wVTt7YBm0jb4Q5Th.OevK_8jqpkv5Ak
 642oeBp8cD.S6H4KNE7zbE7ZtBBJsLxaFV._GJ1h6v_gqUXw05bRkYzNsasPNnFw22dcQKxkbJqi
 lOvCtnMhVXMTT6WIz3k9Qbi7XMYDh516q59dTBTOqO8fT3DA.BTnLnR4opLvXPN8da2VvtbM44ii
 zwHYYcaTD5Lx16DSASgKvYvJGlj3yXN4S5pd2xEKFjYN1pscupooyNcRRDBUd.w4YrdHBguriLFd
 jmJXXPj12uS4xMLS0OLRqgw96GntHHrefkDQSQMHk24e.trLPBkrJUXoV41aRiYG0NMJ6aVdlKho
 FLOqsqCtFtImd.RqVTPxfRhTh8Q.SKAMqmG0wMj.ycOA5R65L_9g908JMC_mRB.APSXAFFwAg4S5
 ovo1ZlbY2mSkaJSjsDMskM0bZy1JP3gVzLg17iCCZi07rxXu0qTyXhvoL6H5EaXSygmJ_YtI9c3t
 iNm4nZnVj3DSnd6qCMn8l5F6Jpl_kCm3fYNIUd5gceIJJD3lPDg8TB_vFFci7.nrM5Iy4bJRMhId
 HpS1JGTLAHPfg7kRs662oXQmj.JyhbSAmu54zVWKte5M7MbeeTIw_du1avma.JNaUgbf4454Vd74
 uoaMuY0cVv1XxtV4tBUD6_fK73OzqATT9flpoVBoQMDkKhkHNc1VqhUO1d7z2zYoNt5E0HBf15Ki
 Aun4OADWX.DmrVYXm6e1SrVMuB.t5VAQh5avNLY0E6cKGiYxBOJV6cKEAAg0kiTIj9uuzOc9_9tZ
 LaazvcdIpel1yiFUa9Q6nT_e6laK8ZIF.s0eTh8ogl02.Rz7Vy5MeZIyKhVMTiZh.QJFPiHZFYSA
 m6m6h5NeAO5Y4ijyG0Esfxbre8GAjatkGpWUgoIk2WrSwFo0qF1H9k.v8PLmTEzPxTBXyxfmoPhs
 G_Wf4ck7kyKYs5RVKTirbcqUlzlB2Eabu3zw9qA7KyfklqXK8o.gnhg.y0nUdEecDIHG_ClQ7bBU
 OUpaeeya.sPlhOX0jVgZdMzVxKmFUbDGWVrAllAIu3N385umQHSqc2RED6Y2y9ysJHTp8e.gVZQ.
 U1fAEhCi_2Rm_19oeF7sT7LafsCTmsK3qVjMKCIxRCH5MTstwheMwZLHf7Vz3pDX6vkr96eJg9eN
 d3Mdtg1DTGA4zOQ1SsQQaWxpWB6HfrEbAUN9vM5VCL_O.Iu6RW34tVwNgOfpyj7BAkRJ5Uwh6Ov8
 7yAlXgD2poCMbFpHTnJNQId0JLEVQ15MCVTCtSyEyVC_jRHZi.xqVelgQlY7fG.bK6hIpwd4p80K
 TVO4pWyuxEGw4tlTIXFx5yNHpxbSgbcCVU8haZWgDSY9pM5mHwT7j0IvdXf0paqG65QnAqNvPGEE
 uZmKLmVc5TdjreBrfqiRmJu5faRCXyCtrS7vk.gX07T_JtaUuF8xWmIAAXALqEEcqQ3Go7vTB5uJ
 t4tJ35uoHxucCdzVxuQCjIHHt6ZaSpKLwVJzWYESilDmtioFgrhey41575kzJz9kTvX9_G.qc5c4
 GSmUcnOJMPRf_eADOLmCc3v.3dUvGNsPdeouDHAMnTU9elwc4mRTDlIMvJDp0InVTvgKE4os6oCB
 7Ri0UyP3muh2Ql0NWF3okexM6H0ITeBRzmjehPeItQhQVRA2.rMdOMrI8TmF.6w2iLDOTAVhMdmN
 o9.86tb55aH6gyqSgvS725X3iCYMIgsWgDzcvlTKPxJBUiHMyTkJy02GmKEDKvp6AAfak3L9ZJFO
 kdDWkjng2OYt8.Ou5WRFOoxPrXKn1C7h5Dy2WtOfn75WAlI_cSDmzAVlYQ94jpp6z2rouFrpJsGw
 9qRwCyidn4725jqjTG.7tLO3quwp7F8.L0LlW8yIaDhkQnFJCKHAhHqunRGIxgMwHiLrCxDz2Ldf
 CvZOtRF3uIopySC6Cvw4xZebEq2fBIkU_arY4CAW.GAZr6faVjQlxJwE28QydMsuH2eYLG67Hyso
 rRzI0O6q9rM6F.uOFhdU7fkYRm51Sasu._x_Wbf5Glf7aJXCmdqMuOTMhnZkrDz9KsWA7OcxRbHq
 1cvPd8EKBGEmAGJg565znA3L1BZhxyz_2q05SukGr1GVGCzghOgt3d5ED_AMCUQ9_jRvWipVPTsq
 SoJ96JJyftcwQGCkNrURT1OZBDCb9m3oTT52OPXzb4C_PvF2CFc3ZmvXa0YdsRRt1_oE.jg4AnvJ
 g2J5EAMCubnan9GmOjRtOfj23IlY.EASbKz9AEJN4hQ--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 473a33d2-9797-4f38-8d7b-df1ee892c69d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 12 Mar 2024 18:51:25 +0000
Received: by hermes--production-gq1-5c57879fdf-hjdnf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7827e58d8a097c72fc3e89eabf3f0a6a;
          Tue, 12 Mar 2024 18:51:22 +0000 (UTC)
Message-ID: <568fae5e-a6d4-4832-a1a1-ac3f4f93d650@schaufler-ca.com>
Date: Tue, 12 Mar 2024 11:51:20 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM
 hook
Content-Language: en-US
To: Fan Wu <wufan@linux.microsoft.com>, Eric Biggers <ebiggers@kernel.org>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org,
 linux-kernel@vger.kernel.org, Deven Bowers
 <deven.desai@linux.microsoft.com>, Casey Schaufler <casey@schaufler-ca.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain>
 <20240312030712.GF1182@sol.localdomain>
 <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.22129 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 3/12/2024 11:14 AM, Fan Wu wrote:
>
>
> On 3/11/2024 8:07 PM, Eric Biggers wrote:
>> On Mon, Mar 11, 2024 at 07:57:12PM -0700, Eric Biggers wrote:
>>>
>>> As I've said before, this commit message needs some work.  It
>>> currently doesn't
>>> say anything about what the patch actually does.
>>>
>>> BTW, please make sure you're Cc'ing the fsverity mailing list
>>> (fsverity@lists.linux.dev), not fscrypt
>>> (linux-fscrypt@vger.kernel.org).
>>
>> Also, I thought this patch was using a new LSM hook, but I now see
>> that you're
>> actually abusing the existing security_inode_setsecurity() LSM hook. 
>> Currently
>> that hook is called when an xattr is set.  I don't see any precedent for
>> overloading it for other purposes.  This seems problematic, as it
>> means that a
>> request to set an xattr with the name you chose
>> ("fsverity.builtin-sig") will be
>> interpreted by LSMs as the fsverity builtin signature.  A dedicated
>> LSM hook may
>> be necessary to avoid issues with overloading the existing xattr hook
>> like this.
>>
>> - Eric
>
> Thanks for the suggestion. I found that using
> security_inode_setsecurity() causes issues with SMACK's
> inode_setsecurity() hook. I will crate a dedicated new hook like
> security_inode_setsig() in the next version.

What is the issue you encountered with the Smack hook?

>
> -Fan
>

